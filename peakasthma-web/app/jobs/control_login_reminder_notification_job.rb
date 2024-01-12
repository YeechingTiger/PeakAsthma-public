class ControlLoginReminderNotificationJob < ControlPatientNotificationJob

  def perform
    patients_to_notify = ControlPatient.joins(:user).where("timezone('utc', CURRENT_TIMESTAMP) - current_sign_in_at > interval '4 days'")
    
    if patients_to_notify.count > 0
      for control_patient in patients_to_notify
        l_notification = create_control_login_reminder_notification(control_patient)
        super(l_notification, control_patient)
      end
    end
  end

  private
    def create_control_login_reminder_notification(control_patient)
      @message = "Hey! Where did you go? Don’t forget to log to get your reward."

      ControlNotification.create(
        alert: 12,
        control_patients: [ control_patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
