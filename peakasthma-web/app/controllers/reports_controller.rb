class ReportsController < ApplicationController
  authenticated!
  before_action :redirect_wrong_patient
  before_action :find_patient, only: [:show]

  def show
    enroll_date = Date.parse(@patient.created_at.to_s)
    @start_date = enroll_date + (Integer(params[:id]) - 1) * 30
    @end_date = (enroll_date + Integer(params[:id]) * 30) - 1

    @green_count = 0
    @yellow_count = 0
    @red_count = 0

    peak_flows = @patient.peak_flows.where(created_at: (@start_date..@end_date)).order("created_at asc")
    filtered = []
    current_date = Date.parse(peak_flows[0].created_at.to_s) if !peak_flows.empty?
    current_level = peak_flows[0].level() if !peak_flows.empty?
    for p in peak_flows
      level = p.level()
      if current_date === Date.parse(p.created_at.to_s)
        if compare(current_level, level) == -1
          current_level = level
        end
      else
        filtered << { date: current_date, level: current_level }
        current_date = Date.parse(p.created_at.to_s)
        current_level = level
      end
    end
    filtered << { date: current_date, level: current_level } if !peak_flows.empty?

    for r in filtered
      if r[:level] == :green
        @green_count += 1
      elsif r[:level] == :yellow
        @yellow_count += 1
      else
        @red_count += 1
      end
    end

    month = Integer(params[:id])
    data = RedcapAPI.get_patient_monthly_survey(@patient.redcap_id, month)

    if data != nil
      if month == 6 || month == 9
        @emt = Integer(data[0]['m69_er'])
        @hospital = Integer(data[0]['m69_overnight'])
        @doctor = Integer(data[0]['m69_dr'])
        @rescue = Integer(data[0]['m69_rescue'])
      else
        @emt = Integer(data[0]['m_er'])
        @hospital = Integer(data[0]['m_overnight'])
        @doctor = Integer(data[0]['m_dr'])
        @rescue = Integer(data[0]['m_rescue'])
      end
    else
      @emt = 0
      @hospital = 0
      @doctor = 0
      @rescue = 0
    end
  end

  private
    def find_patient
      @patient = Patient.find(params[:patient_id])
    end

    def compare(l, r)
      l_index = PeakFlow::LEVELS.find_index(l)
      r_index = PeakFlow::LEVELS.find_index(r)
      l_index <=> r_index
    end
end
