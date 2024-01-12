class ControlPatientRewardRecordJob < ApplicationJob
    # This job will run one time everyday, and updated record or new found record will be added to the database

    def perform
        control_patient_months_to_save = get_control_patient_months
        # Check the survey status and create or update new record
        for p in control_patient_months_to_save
          control_patient_reward_record = ControlPatientRewardRecord.where("control_patient_id = ? and month = ?", p[:patient].id, p[:month]).first
          if (control_patient_reward_record != nil and control_patient_reward_record.survey_complete == false)
            # check survey status 
            data = RedcapAPI.get_patient_monthly_survey(p[:patient].redcap_id, p[:month])
            if data == nil
              # Survey not completed, do nothing, keep the original record
              # puts "updating-----------------------------"
            else
              # Survey completed, update the record
              # puts "updating-----------------------------"
              # puts data[0]
              survey_finish_date = (data[0]["m_date"] != nil) ? DateTime.parse(data[0]["m_date"]) : DateTime.parse(data[0]["m69_date"])

              control_patient_reward_record.update(survey_complete:true, survey_complete_day:survey_finish_date)
            end
          elsif control_patient_reward_record == nil
            # create new one
            p_reward_record = ControlPatientRewardRecord.new
            p_reward_record.control_patient_id = p[:patient].id
            p_reward_record.logging_over_day = p[:over_date]
            p_reward_record.payment_amount = p[:payment_amount]
            p_reward_record.month = p[:month]

            data = RedcapAPI.get_patient_monthly_survey(p[:patient].redcap_id, p[:month])
            if data == nil
              p_reward_record.survey_complete = false
            else
              # Survey completed, update the record
              # puts data[0]
              survey_finish_date = (data[0]["m_date"] != nil) ? DateTime.parse(data[0]["m_date"]) : DateTime.parse(data[0]["m69_date"])
              # puts p_reward_record
              p_reward_record.survey_complete = true
              p_reward_record.survey_complete_day = survey_finish_date
            end

            p_reward_record.save

          end
          
        end
      end
    
      private
        # Get every month's reward information
        def get_control_patient_months
          patients = ControlPatient.all
          patient_months = []
          today = Time.now.utc.to_date
          for p in patients
            @monthly_rewards_days = Hash.new
            enroll_date = Date.parse(p.created_at.to_s)
            days = (today - p.created_at.to_date).to_i
            current_month = days / 30 + 1

            # Compute incentives 
            for i in (1..current_month)
              @monthly_rewards_days[i] = 0
            end
            @all_incentives = ControlIncentiveRecord.where(control_patient_id: p.id).order(month: :asc, week: :asc, day: :asc)
            @all_incentives = @all_incentives.to_a
            @all_incentives.each_with_index do |incentive, index|
              total_days = (incentive.week - 1) * 7 + incentive.day
              true_month = (total_days - 1) / 30 + 1
              if @monthly_rewards_days.include?(true_month) and @monthly_rewards_days[true_month] >= 20
                @all_incentives[index].get_incentive = false
              else
                @all_incentives[index].get_incentive = true
                @monthly_rewards_days[true_month] += 1
              end 
            end

            # Add information to month
            for month in (1..current_month-1)
              over_date = (enroll_date + month * 30) - 1
              patient_months << {
                over_date: over_date,
                patient: p,
                month: month,
                payment_amount: @monthly_rewards_days[month]*0.75
              }
            end
          end
          patient_months
        end
  end