class MedicationCustomReminderNotificationJob < PatientNotificationJob
  queue_as :med_reminder

  def perform(patient, color)
        if color == "green"
          m_notification = create_medication_reminder_notification(patient)
          super(m_notification, patient)
        else
          m_notification = create_yellow_medication_reminder_notification(patient)
          super(m_notification, patient)
        end
  end

  private
    def create_medication_reminder_notification(patient)
      @message = "Don’t forget to take your control medications!"
      Notification.create(
        alert: 3,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def create_yellow_medication_reminder_notification(patient)
      @message = "Don’t forget to take your yellow zone medications!"
      Notification.create(
        alert: 5,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
