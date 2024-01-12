RSpec.describe MedicationReminderNotificationJob, type: :job do
  let!(:user) { Fabricate :user }

  describe 'medication reminder notifications' do
    it 'sends the user a notification when they are within 5 minutes of the check' do
      user.patient.update(medication_reminders: true)
      user.patient.update(medication_reminder_time: Time.current - 3.minutes)

      res = MedicationReminderNotificationJob.perform_now
      notification = Notification.last

      expect(res.code).to eq '200'
      expect(notification.sent).to eq true
      expect(notification.patients).to eq [ user.patient ]
      expect(notification.message).to eq I18n.t('patient.notifications.medication_reminder')
      expect(notification.alert).to eq false
    end

    it 'does not send the user a notification when they are within 5 minutes of the check' do
      user.patient.update(medication_reminders: true)
      user.patient.update(medication_reminder_time: Time.current - 6.minutes)
      
      res = MedicationReminderNotificationJob.perform_now
      notification = Notification.last

      expect(res).to eq nil
      expect(notification).to eq nil
    end

    it 'does not send the user a notification when they do not want to receive updates' do
      user.patient.update(medication_reminders: false)
      
      res = MedicationReminderNotificationJob.perform_now
      notification = Notification.last

      expect(res).to eq nil
      expect(notification).to eq nil
    end
  end
end
