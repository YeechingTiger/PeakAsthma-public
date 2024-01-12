class FeelingReminderNotificationJob < PatientNotificationJob

  def perform(patient)
    notification = create_feeling_reminder_notification(patient)
    super(notification, patient)

  end

  private
    def create_feeling_reminder_notification(patient)
      notification = Notification.create(
        alert: 1,
        patients: [patient],
        message: "Please record your peak flow or symptoms.",
        send_at: DateTime.current)
    end
  end
