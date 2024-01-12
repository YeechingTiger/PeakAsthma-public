class SendTipsJob < PatientNotificationJob
  queue_as :default

  def perform
    @patients = Patient.all
    @patients.each do |patient|
      # puts patient.inspect
      @days = days_after_enroll(patient)
      @week = (@days / 7) + 1
      @week_day = @days % 7
      puts @week_day
      @tips = find_tip(@week)
      if @week_day == 0
        for @tip in @tips
          @notification = create_weekly_tips_notification(patient, @tip['tip'])
          super(@notification, patient)
        end
      end
    end
  end

  private
    def create_weekly_tips_notification(patient, tip)
      @message = tip
      Notification.create(
        patients: [patient],
        message: @message,
        send_at: DateTime.current)
    end

    def find_tip(week)
      @week_i = week.to_i
      Tip.where(schedule: @week_i)
    end

    def days_after_enroll(patient)
      @enroll_date = patient.created_at.to_date
      puts @enroll_date
      @current_date = Time.now.utc.to_date
      puts @current_date
      @days = @current_date - @enroll_date
      @days = @days.to_i
    end
end
