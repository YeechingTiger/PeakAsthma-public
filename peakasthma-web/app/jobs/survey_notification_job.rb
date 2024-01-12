class SurveyNotificationJob < PatientNotificationJob

  def perform
    patients_to_notify = calc_new_survey_month
    
    for p in patients_to_notify
      link = RedcapAPI.get_survey_link(p[:patient].redcap_id, p[:month])
      if link != nil
        s_notification = create_survey_notification(p[:patient], p[:month], link)
        super(s_notification, p[:patient])
      end
    end
  end

  private
    def create_survey_notification(patient, month, link)
      @message = "Please take a minute to fill out the #{month}#{month.ordinal} month survey! Click this link to redirect: #{link}"

      Notification.create(
        alert: 11,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def calc_new_survey_month
      patients = Patient.where("now()::date != created_at::date and (now()::date - created_at::date) % 30 = 0")

      patient_months = []
      # today = Date.today
      today = Date.parse(ActiveRecord::Base.connection.exec_query("SELECT now()::date").first["now"])
      for p in patients
        if p.user.disabled == false
          month = (today - Date.parse(p.created_at.to_s)).to_i / 30

          patient_months << {
            patient: p,
            month: month
          }
        end
      end

      patient_months
    end
end
