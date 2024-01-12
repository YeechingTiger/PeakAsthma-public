RSpec.describe PatientNotificationJob, type: :job do
  let!(:user) { Fabricate :user }
  let!(:notification) { Fabricate :notification, patients: [ user.patient ], author: user, message: 'test' }

  describe 'peak_flow notifications' do
    it 'sends out the http request to send the push notification' do
      res = PatientNotificationJob.perform_now notification
      last_notification = user.patient.notifications.last

      expect(res.code).to eq '200'
      expect(last_notification.sent).to eq true
      expect(last_notification.patients).to eq notification.patients
      expect(last_notification.message).to eq notification.message
    end
  end
end
