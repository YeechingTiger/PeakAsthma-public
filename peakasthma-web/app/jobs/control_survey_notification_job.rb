class ControlSurveyNotificationJob < ControlPatientNotificationJob

  def perform
    control_patients_to_notify = calc_new_survey_month
    
    for p in control_patients_to_notify
      link = RedcapAPI.get_survey_link(p[:control_patient].redcap_id, p[:month])
      if link != nil
        s_notification = create_control_survey_notification(p[:control_patient], p[:month], link)
        super(s_notification, p[:control_patient])
      end
    end
  end

  private
    def create_control_survey_notification(control_patient, month, link)
      @message = "Please take a minute to fill out the #{month}#{month.ordinal} month survey! Click this link to redirect: #{link}"

      ControlNotification.create(
        alert: 11,
        control_patients: [ control_patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def calc_new_survey_month
      control_patients = ControlPatient.where("now()::date != created_at::date and (now()::date - created_at::date) % 30 = 0")

      patient_months = []
      # today = Date.today
      today = Date.parse(ActiveRecord::Base.connection.exec_query("SELECT now()::date").first["now"])
      for p in control_patients
        if p.user.disabled == false
          month = (today - Date.parse(p.created_at.to_s)).to_i / 30

          patient_months << {
            control_patient: p,
            month: month
          }
        end
      end

      patient_months
    end
end
