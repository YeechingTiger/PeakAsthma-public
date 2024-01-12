describe User do
  subject { Fabricate :user }
  
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe '#patient model' do
    it 'destroys patient model if user has a patient model associated' do
      new_user = Fabricate :user
      expect { new_user.destroy }.to change{ Patient.count }.by(-1)
    end
  end

  describe '#first_initial' do
    it 'should return the first letter of a user\'s first name' do
      expect(subject.first_initial).to eq subject.first_name[0]
    end
  end

  describe '#last_name_first_initial' do
    it 'should return the first letter of a user\'s first name' do
      expect(subject.last_name_first_initial).to eq "#{subject.last_name}, #{subject.first_initial}."
    end
  end

  describe '#first_mobile_login?' do
    let(:old_user) { Fabricate :user, used_mobile_app: true }
    let(:new_user) { Fabricate :user, used_mobile_app: false }

    it 'returns false if the user has logged in before' do
      expect(old_user.first_mobile_login?).to eq false
    end

    it 'returns true if this is the users first sign in' do
      expect(new_user.first_mobile_login?).to eq true
    end
  end
end