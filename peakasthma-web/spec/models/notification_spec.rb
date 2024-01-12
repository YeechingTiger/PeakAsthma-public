RSpec.describe Notification do
  include ActiveJob::TestHelper
  let!(:sent_notification) { Fabricate :notification, sent: true, created_at: 99.days.ago }

  let!(:patient_params) { Fabricate.attributes_for(:patient) }
  let!(:user_a) { Fabricate :user }
  let!(:user_b) { Fabricate :user }

  it { is_expected.to validate_presence_of :send_at }
  it { is_expected.to validate_presence_of :message }

  describe '#open_rate' do
    it 'gives me an accurate open rate for notifications' do
      sent_notification.update(patients: [user_a.patient, user_b.patient])
      expect(sent_notification.open_rate).to eq(0.0)

      read_notification_record = Fabricate :read_notification_record, patient: user_a.patient, notification: sent_notification
      expect(sent_notification.open_rate).to eq(0.5)

      read_notification_record = Fabricate :read_notification_record, patient: user_b.patient, notification: sent_notification
      expect(sent_notification.open_rate).to eq(1.0)
    end
  end
end
