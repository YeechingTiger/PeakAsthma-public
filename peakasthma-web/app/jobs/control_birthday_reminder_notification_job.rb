class ControlBirthdayReminderNotificationJob < ControlPatientNotificationJob

  def perform
    current_time = Time.new
    year = current_time.year
    month = current_time.month
    day = current_time.day

    patients_to_notify = ControlPatient.where("extract(month from birthday) = ? and extract(day from birthday) = ?", month, day)
    
    if patients_to_notify.count > 0
      for control_patient in patients_to_notify
        l_notification = create_control_birthday_reminder_notification(control_patient)
        super(l_notification, control_patient)
      end
    end
  end

  private
    def create_control_birthday_reminder_notification(control_patient)
      @message = "Happy Birthday!"

      ControlNotification.create(
        alert: 12,
        control_patients: [ control_patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
