class PrescriptionReminderNotificationJob < PatientNotificationJob

  def perform
    prescriptions_to_notify = []
    @prescriptions = Prescription.where(valid_status: true)
    for @prescription in @prescriptions
      @reminder_day = @prescription.reminder_day
      puts should_notify(@reminder_day)
      if(should_notify(@reminder_day))
        prescriptions_to_notify.push(@prescription)
      end
    end
    
    if prescriptions_to_notify.count > 0
      for prescription in prescriptions_to_notify
        notification = create_prescription_reminder_notification(prescription)
        super(notification, prescription.patient)
      end
    end
  end

  private
    def create_prescription_reminder_notification(prescription)
      @medicine = prescription.medication.name
      @message = "Don’t forget to refill your #{ @medicine }!"
      Notification.create(
        patients: [ prescription.patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def should_notify(notify_day)
      current_time = Time.new
      year = current_time.year
      month = current_time.month
      day = current_time.day
      puts day
      last_day = Date.new(year, month, -1).day
      if day.to_i == notify_day.to_i
        return true
      elsif day.to_i == last_day.to_i && notify_day.to_i > last_day.to_i
        return true
      else
        return false
      end
    end
end
