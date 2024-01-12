RSpec.describe PatientExacerbationMailer, type: :mailer do
  describe '#yellow_patient_exacerbation_email' do
    let!(:user) { Fabricate :user }
    let!(:patient) { user.patient }
    let!(:guardian) { Fabricate :guardian, patient: patient }
    let!(:admin) { Fabricate :user, role: 'admin' }

    it 'should send an email to admins' do
      expect do
        described_class.yellow_patient_exacerbation_email(patient).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    describe 'sent email' do
      let(:mail) { described_class.yellow_patient_exacerbation_email(patient).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq('Yellow Patient Exacerbation Zone')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([admin.email, guardian.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['notifications@willow.com'])
      end
    end
  end

  describe '#red_admin_exacerbation_email' do
    let!(:user) { Fabricate :user }
    let!(:patient) { user.patient }
    let!(:guardian) { Fabricate :guardian, patient: patient }
    let!(:admin) { Fabricate :user, role: 'admin' }

    it 'should send an email to admins' do
      expect do
        described_class.red_patient_exacerbation_email(patient).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    describe 'sent email' do
      let(:mail) { described_class.red_patient_exacerbation_email(patient).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq('Red Patient Exacerbation Zone')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([admin.email, guardian.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['notifications@willow.com'])
      end
    end
  end
end
