class DailyReminderNotificationJob < ControlPatientNotificationJob

  def perform
    current_time = Time.current.utc.to_s(:time)
    time_of_last_check = (Time.current.utc - 2.minutes).to_s(:time)
    patients_to_notify = ControlPatient.where("daily_reminders = true AND daily_reminder_time::time > ? AND daily_reminder_time::time <= ?", time_of_last_check, current_time)

    if patients_to_notify.count > 0
      for patient in patients_to_notify
        d_notification = create_daily_reminder_notification(patient)
        super(d_notification, patient)
      end
    end
  end

  private
    def create_daily_reminder_notification(patient)
      @message = "Log yesterday's diet and remember to eat your fruits and vegetables again today."

      ControlNotification.create(
        alert: 0,
        control_patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
