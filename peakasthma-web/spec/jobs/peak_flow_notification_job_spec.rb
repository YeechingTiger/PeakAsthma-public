RSpec.describe PeakFlowNotificationJob, type: :job do
  let!(:user) { Fabricate :user }
  let!(:guardian) { Fabricate :guardian, patient: user.patient }
  let!(:admin) { Fabricate :user, role: 'admin' }
  let!(:peak_flow) { Fabricate :peak_flow, patient: user.patient }

  describe 'peak_flow notifications' do
    it 'sends out the http request to send the push notification' do
      res = PeakFlowNotificationJob.perform_now peak_flow, I18n.t('patient.notifications.how_are_you_feeling')
      notification = user.patient.notifications.last

      expect(res.code).to eq '200'
      expect(notification.sent).to eq true
      expect(notification.patients).to eq [ user.patient ]
      expect(notification.message).to eq I18n.t('patient.notifications.how_are_you_feeling')
      expect(notification.alert).to eq true
    end

    it 'Sends out a yellow admin exacerbation email when the level is yellow' do
      user.patient.update yellow_zone_maximum: 100, yellow_zone_minimum: 50
      peak_flow.update score: 75

      expect(PatientExacerbationMailer).to receive(:yellow_patient_exacerbation_email).once
      res = PeakFlowNotificationJob.perform_now peak_flow, I18n.t('patient.notifications.how_are_you_feeling')
    end

    it 'Sends out a red admin exacerbation email when the level is red' do
      user.patient.update yellow_zone_maximum: 100, yellow_zone_minimum: 50
      peak_flow.update score: 25

      expect(PatientExacerbationMailer).to receive(:red_patient_exacerbation_email).once
      res = PeakFlowNotificationJob.perform_now peak_flow, I18n.t('patient.notifications.how_are_you_feeling')
    end

    it 'Does not send out any response if the peak flow provided is not the users latest record' do
      Fabricate :peak_flow, patient: user.patient
      res = PeakFlowNotificationJob.perform_now peak_flow, I18n.t('patient.notifications.how_are_you_feeling')

      expect(res).to eq nil
    end
  end
end
