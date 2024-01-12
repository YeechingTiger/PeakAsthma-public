class SurveyReminderNotificationJob < PatientNotificationJob

  def perform
    patients_to_remind = calc_reminder

    for p in patients_to_remind
      link = RedcapAPI.get_survey_link(p[:patient].redcap_id, p[:month])
      if link != nil
        r_notification = create_survey_reminder_notification(p[:patient], p[:month], link)
        super(r_notification, p[:patient])
      end
    end
  end

  private
    def create_survey_reminder_notification(patient, month, link)
      @message = "It seems like you haven't filled out the #{month}#{month.ordinal} month survey! Click this link to redirect: #{link}"

      Notification.create(
        alert: 11,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def calc_reminder
      patients = Patient.all
      all_reminders = []
      today = Date.today

      for p in patients
        if p.user.disabled == false
          date = Date.parse(p.created_at.to_s)
          diff = (today - date).to_i
          latest_survey_month = (diff - 1) / 30

          if latest_survey_month == 0 || (diff - 1) % 30 > 7
            next
          end

          if RedcapAPI.get_patient_monthly_survey(p.redcap_id, latest_survey_month) == nil
            all_reminders << {
              patient: p,
              month: latest_survey_month
            }
          end
        end
      end

      all_reminders
    end
end
