module API
    class IncentiveController < ApplicationController
        authenticated!

        def incentive
            @week_incentives = IncentiveRecord.where(patient_id: current_user.patient.id, month: month, week: week)
            @month_incentives = IncentiveRecord.where(patient_id: current_user.patient.id, month: month, get_incentive: true)
            respond_to do |format| 
                format.json { render json: {week_days: @week_incentives.length, month_days: @month_incentives.length} }
            end
        end

        private
            def days_after_enroll()
                @enroll_date = (current_user.patient.created_at - 6.hours).to_date
                puts @enroll_date
                @current_date = (Time.now.utc - 6.hours).to_date
                puts @current_date
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
