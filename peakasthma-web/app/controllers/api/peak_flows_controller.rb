module API
  class PeakFlowsController < API::BaseController
    skip_before_action :verify_authenticity_token, raise: false
    authenticated!

    def create
      new_peak_flow_params = peak_flow_params
      if params[:symptoms]
        symptom_ids = params[:symptoms].map { |symptom| symptom['id'] }
        new_peak_flow_params[:symptoms] = Symptom.find(symptom_ids)
      end

      @peak_flow = current_user.patient.peak_flows.create(new_peak_flow_params)
      if @peak_flow.level == :yellow || @peak_flow.level == :red || @peak_flow.level == :red_now
        @prescription = current_user.patient.recommended_prescription_for_level(@peak_flow.level)
        FeelingReminderNotificationJob.set(wait: 20.minutes).perform_later(current_user.patient)
      end

      record_incentive()

      respond_with @peak_flow
    end

    def index
      @peak_flows = current_user.patient.peak_flows.order('created_at desc').limit(7)
      respond_with @peak_flows
    end

    private
      def peak_flow_params
        params.permit(:score, :symptoms, :peak_flow, :feeling)
      end

      def days_after_enroll()
        @enroll_date = current_user.patient.created_at.to_date
        @current_date = Time.zone.now.to_s.to_date
        @days = @current_date - @enroll_date
        @days = @days.to_i
      end

      def record_incentive
        if !is_incentive_logged_today
          @get_incentive = should_get_incentive()
          puts "======================="
          puts @get_incentive
          IncentiveRecord.create(month: month, week: week, day: day, get_incentive: @get_incentive, patient_id: current_user.patient.id)
        end
      end

      def should_get_incentive
        @week_incentive = IncentiveRecord.where(patient_id: current_user.patient.id, month: month, week: week)
        @length = @week_incentive.length
        puts @week_incentive
        puts @length
        if @length >= 5
          return false
        else
          return true
        end
      end

      def is_incentive_logged_today
        @incentive = IncentiveRecord.where(patient_id: current_user.patient.id, month: month, week: week, day: day)
        if @incentive.length != 0
          return true
        else 
          return false
        end 
      end

      def day
        @days = days_after_enroll()
        @week_day = (@days % 7) + 1
      end

      def week
        @days = days_after_enroll()
        @week = (@days / 7) + 1
      end

      def month
        @month = ((week - 1) / 4) + 1 
      end
  end
end
