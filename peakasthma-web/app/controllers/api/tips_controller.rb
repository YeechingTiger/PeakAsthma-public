module API
  class TipsController < API::BaseController
    require 'net/http'

    # authenticated!
  
    def get_tip
        @day = days_after_enroll()
        @week = (@day / 7) + 1
        puts @week
        @tips = Tip.where(schedule: @week.to_i)
        respond_with @tips
    end

    def get_weather
      api_key = ''
      @lat = params[:lat]
      @lon = params[:lon]

      accuweather_location_url = URI.parse('http://dataservice.accuweather.com/locations/v1/cities/geoposition/search')
      http = Net::HTTP.new(accuweather_location_url.host, accuweather_location_url.port)
      query_params = {
        apikey: api_key,
        q: "#{@lat},#{@lon}"
      }
      accuweather_location_url.query = URI.encode_www_form(query_params)
      req = Net::HTTP::Get.new(accuweather_location_url.to_s)

      res = http.request(req)

      if res.code == '200'
        data = JSON.parse(res.body)
        @loc_key = data['Key']
      end

      if @loc_key
        # current
        accuweather_current_url = URI.parse("http://dataservice.accuweather.com/currentconditions/v1/#{@loc_key}")
        http = Net::HTTP.new(accuweather_current_url.host, accuweather_current_url.port)
        query_params = {
          apikey: api_key,
          details: 'true'
        }
        accuweather_current_url.query = URI.encode_www_form(query_params)
        req = Net::HTTP::Get.new(accuweather_current_url.to_s)

        res = http.request(req)

        if res.code == '200'
          data = JSON.parse(res.body)
          @current = data
        end

        # forecast
        accuweather_forecast_url = URI.parse("http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{@loc_key}")
        http = Net::HTTP.new(accuweather_forecast_url.host, accuweather_forecast_url.port)
        query_params = {
          apikey: api_key,
          details: 'true'
        }
        accuweather_forecast_url.query = URI.encode_www_form(query_params)
        req = Net::HTTP::Get.new(accuweather_forecast_url.to_s)

        res = http.request(req)

        if res.code == '200'
          data = JSON.parse(res.body)
          @forecast = data
        end


        days = []
        for f in @forecast["DailyForecasts"]
          days << {
            date: f["Date"],
            icon: f["Day"]["Icon"],
            temperatureMax: f["Temperature"]["Maximum"]["Value"],
            temperatureMin: f["Temperature"]["Minimum"]["Value"],
            pollen: highest_pollen_level(f["AirAndPollen"])
          }
        end

        @weather = {
          "currentText" => @current[0]["WeatherText"],
          "currentIcon" => @current[0]["WeatherIcon"],
          "currentTemperature" => @current[0]["Temperature"]["Imperial"]["Value"],
          "currentRealFeelTemperature" => @current[0]["RealFeelTemperature"]["Imperial"]["Value"],
          "currentHumidity" => @current[0]["RelativeHumidity"],
          "currentPollen" => highest_pollen_level(@forecast["DailyForecasts"][0]["AirAndPollen"]),
          "summary" => @forecast["Headline"]["Text"],
          "days" => days
        }
      else
        @weather = ""
      end

      respond_to do |format| 
        format.json { render json: {data: @weather } }
      end
    end

    private

    def days_after_enroll
        @enroll_date = current_user.created_at
        @current_time = Time.new
        @time = @current_time - @enroll_date
        puts @time / (24*60*60)
        return @time / (24*60*60)
    end

    def highest_pollen_level(air)
      levels = ["low", "moderate", "high", "unhealthy", "hazardous"]
      relevant_pollutant = ["grass", "ragweed", "tree"]
      pollens = []
      air.each { |a| pollens << a["Category"].downcase if relevant_pollutant.include?(a["Name"].downcase)}
      pollens.max_by { |p| levels.find_index(p) }
    end

  end
end
