class LoginReminderNotificationJob < PatientNotificationJob

  def perform
    patients_to_notify = Patient.joins(:user).where("timezone('utc', CURRENT_TIMESTAMP) - current_sign_in_at > interval '4 days'")
    
    if patients_to_notify.count > 0
      for patient in patients_to_notify
        l_notification = create_login_reminder_notification(patient)
        super(l_notification, patient)
      end
    end
  end

  private
    def create_login_reminder_notification(patient)
      @message = "Hey! Where did you go? Don’t forget to log to get your reward."

      Notification.create(
        alert: 12,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
