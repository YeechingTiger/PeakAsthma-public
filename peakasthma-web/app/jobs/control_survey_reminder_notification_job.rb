class ControlSurveyReminderNotificationJob < ControlPatientNotificationJob

  def perform
    control_patients_to_remind = calc_reminder

    for p in control_patients_to_remind
      link = RedcapAPI.get_survey_link(p[:control_patient].redcap_id, p[:month])
      if link != nil
        r_notification = create_control_survey_reminder_notification(p[:control_patient], p[:month], link)
        super(r_notification, p[:control_patient])
      end
    end
  end

  private
    def create_control_survey_reminder_notification(control_patient, month, link)
      @message = "It seems like you haven't filled out the #{month}#{month.ordinal} month survey! Click this link to redirect: #{link}"

      ControlNotification.create(
        alert: 11,
        control_patients: [ control_patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def calc_reminder
      control_patients = ControlPatient.all
      all_reminders = []
      today = Date.today

      for p in control_patients
        if p.user.disabled == false
          date = Date.parse(p.created_at.to_s)
          diff = (today - date).to_i
          latest_survey_month = (diff - 1) / 30

          if latest_survey_month == 0 || (diff - 1) % 30 > 7
            next
          end

          if RedcapAPI.get_patient_monthly_survey(p.redcap_id, latest_survey_month) == nil
            all_reminders << {
              control_patient: p,
              month: latest_survey_month
            }
          end
        end
      end

      all_reminders
    end
end
