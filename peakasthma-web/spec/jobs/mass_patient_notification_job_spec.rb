RSpec.describe MassPatientNotificationJob, type: :job do
  let!(:notification) { Fabricate :notification }
  let!(:users) { Fabricate.times 10, :user }

  it 'sends out the http request to send the push notification' do
    res = MassPatientNotificationJob.perform_now notification

    expect(res.code).to eq '200'
    expect(notification.sent).to eq true
    expect(notification.patients).to eq Patient.all
  end
end
