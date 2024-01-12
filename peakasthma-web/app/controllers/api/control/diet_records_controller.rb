module API::Control
  class DietRecordsController < API::Control::BaseController
    authenticated!
    before_action :find_record, only: [:update]

    def create
      @diet_record = current_user.control_patient.diet_records.create(fruit: params[:fruit], vegetable: params[:vegetable], record_date: params[:date])
      record_incentive()
      respond_with @diet_record
    end

    def index
      @diet_records = current_user.control_patient.diet_records
        .where("record_date < to_date('#{params[:today]}', 'YYYY-MM-DD') and record_date >= (to_date('#{params[:today]}', 'YYYY-MM-DD') - INTERVAL '7 days')")
        .order("record_date asc").limit(7)
      respond_with @diet_records
    end

    def update
      @diet_record.update(record_params)
      respond_with @diet_record
    end

    private
      def find_record
        @diet_record = DietRecord.find(params[:id])
        @diet_record
      end

      def record_params
        params.require(:diet_record).permit(:id, :control_patient_id, :fruit, :vegetable, :record_date)
      end

      def days_after_enroll()
        @enroll_date = current_user.control_patient.created_at.to_date
        @current_date = Time.zone.now.to_s.to_date
        @days = @current_date - @enroll_date
        @days = @days.to_i
      end

      def record_incentive
        if !is_incentive_logged_today
          @get_incentive = should_get_incentive()
          ControlIncentiveRecord.create(month: month, week: week, day: day, get_incentive: @get_incentive, control_patient_id: current_user.control_patient.id)
        end
      end

      def should_get_incentive
        @week_incentive = ControlIncentiveRecord.where(control_patient_id: current_user.control_patient.id, month: month, week: week)
        @length = @week_incentive.length
        if @length >= 5
          return false
        else
          return true
        end
      end

      def is_incentive_logged_today
        @incentive = ControlIncentiveRecord.where(control_patient_id: current_user.control_patient.id, month: month, week: week, day: day)
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
