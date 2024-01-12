RSpec.describe Guardian do
  let!(:user) { Fabricate :user }
  let!(:guardian) { Fabricate :guardian, patient: user.patient }

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :relationship_to_patient }

  describe '#full_name' do
    it 'returns the full name of the guardian' do
      expect(guardian.full_name).to eq "#{guardian.first_name} #{guardian.last_name}"
    end
  end
end
