module API::Control
  class IncentiveController < ApplicationController
    authenticated!

    def incentive
      @week_incentives = ControlIncentiveRecord.where(control_patient_id: current_user.control_patient.id, month: month, week: week)
      @month_incentives = ControlIncentiveRecord.where(control_patient_id: current_user.control_patient.id, month: month, get_incentive: true)
      respond_to do |format|
        format.json { render json: {week_days: @week_incentives.length, month_days: @month_incentives.length} }
      end
    end

    private
      def days_after_enroll()
        @enroll_date = current_user.control_patient.created_at.to_date
        @current_date = Time.now.utc.to_date
        @days = @current_date - @enroll_date
        @days = @days.to_i
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
