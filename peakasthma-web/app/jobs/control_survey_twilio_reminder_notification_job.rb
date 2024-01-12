class ControlSurveyTwilioReminderNotificationJob < ApplicationJob

  def perform
    patients_to_remind = calc_twilio_reminder

    for p in patients_to_remind
      link = RedcapAPI.get_survey_link(p[:patient].redcap_id, p[:month])
      # if link != nil
      send_twilio_survey(p[:patient], link)
      # end
    end
  end

  private
    def boot_twilio
      account_sid = Rails.application.secrets.twilio_sid
      auth_token = Rails.application.secrets.twilio_token
      @client = Twilio::REST::Client.new account_sid, auth_token
    end

    def send_twilio_survey(patient, link)
      @message = "You only have 2 days left to complete your PeakAsthma survey and receive $15. Click the link for the survey:#{link}"
      to_number = patient.phone
      # to_number = '813-573-3122'
      boot_twilio
      puts Rails.application.secrets.twilio_number
      puts patient.phone
      puts to_number
      puts @message
      sms = @client.messages.create(
        from: Rails.application.secrets.twilio_number,
        to: to_number,
        body: @message
      )
    end

    def calc_twilio_reminder
      patients = ControlPatient.all
      all_reminders = []
      today = Date.today

      for p in patients
        if p.user.disabled == false
          @patient_reward_record = ControlPatientRewardRecord.where("control_patient_id=?", p.id).order(logging_over_day: :desc).first
          if @patient_reward_record
            latest_survey_month = @patient_reward_record.month
            survey_start_date = @patient_reward_record.logging_over_day.to_date
            today = Time.now.utc.to_date
            days = (today - survey_start_date).to_i
            puts days
            if days == 5
              if RedcapAPI.get_patient_monthly_survey(p.redcap_id, latest_survey_month) == nil
                all_reminders << {
                  patient: p,
                  month: latest_survey_month
                }
              end
            end
          end
        end
      end

      all_reminders
    end
end
