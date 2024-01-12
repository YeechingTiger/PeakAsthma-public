class BirthdayReminderNotificationJob < PatientNotificationJob

  def perform
    current_time = Time.new
    year = current_time.year
    month = current_time.month
    day = current_time.day
    patients_to_notify = Patient.where("extract(month from birthday) = ? and extract(day from birthday) = ?", month, day)
    
    if patients_to_notify.count > 0
      for patient in patients_to_notify
        l_notification = create_birthday_reminder_notification(patient)
        super(l_notification, patient)
      end
    end
  end

  private
    def create_birthday_reminder_notification(patient)
      @message = "Happy Birthday!"

      Notification.create(
        alert: 12,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
