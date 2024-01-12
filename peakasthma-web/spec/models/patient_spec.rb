RSpec.describe Patient do
  it { is_expected.to validate_presence_of :birthday }
  it { is_expected.to validate_presence_of :gender }
  let!(:user) { Fabricate :user }

  describe 'self.#app_usage_percentage' do
    it 'returns percentages appropriate to the number of users' do
      expect(Patient.app_usage_percentage).to eq 0

      Fabricate :peak_flow, patient: user.patient, score: 300
      expect(Patient.app_usage_percentage).to eq 100

      Fabricate.times 9, :user
      expect(Patient.app_usage_percentage).to eq 10
    end
  end

  describe '#level' do
    it 'returns nil when the user has no peak flows' do
      expect(user.patient.level).to eq nil
    end

    it 'returns green when the user\'s last update is green.' do
      Fabricate :peak_flow, score: user.patient.yellow_zone_maximum + 10, patient: user.patient
      expect(user.patient.level).to eq :green
    end

    it 'returns green when the user\'s last update is green.' do
      Fabricate :peak_flow, score: user.patient.yellow_zone_maximum, patient: user.patient
      expect(user.patient.level).to eq :yellow
    end

    it 'returns green when the user\'s last update is green.' do
      Fabricate :peak_flow, score: user.patient.yellow_zone_minimum - 10, patient: user.patient
      expect(user.patient.level).to eq :red
    end
  end

  describe '#zone_percentage' do
    let(:new_user) { Fabricate :user }

    before do
      Fabricate :peak_flow, patient: new_user.patient, score: new_user.patient.yellow_zone_minimum - 10, created_at: 4.years.ago
      Fabricate :peak_flow, patient: new_user.patient, score: new_user.patient.yellow_zone_minimum + 10, created_at: 2.years.ago
      Fabricate :peak_flow, patient: new_user.patient, score: new_user.patient.yellow_zone_maximum + 10, created_at: 1.years.ago
    end

    it 'describes a model\'s percantage for each level' do
      expect(new_user.patient.zone_percentage(:green)).to eq 25
      expect(new_user.patient.zone_percentage(:yellow)).to eq 25
      expect(new_user.patient.zone_percentage(:red)).to eq 50
    end
  end

  describe '#height_in_feet' do
    it 'returns the recorded height (in inches) in feet' do
      user.patient.height = 72
      expect(user.patient.height_in_feet).to eq '6\' 0"'

      user.patient.height = 73
      expect(user.patient.height_in_feet).to eq '6\' 1"'

      user.patient.height = 83
      expect(user.patient.height_in_feet).to eq '6\' 11"'

      user.patient.height = 84
      expect(user.patient.height_in_feet).to eq '7\' 0"'
    end

    it 'returns \"N/A\" if there isn\'t a recorded height' do
      user.patient.height = nil
      expect(user.patient.height_in_feet).to eq 'N/A'
    end
  end

  describe '#weight_in_pounds' do
    it 'returns the recorded weight (in pounds) with the pounds unit' do
      user.patient.weight = 72
      expect(user.patient.weight_in_pounds).to eq '72.0 lbs'

      user.patient.weight = 72.5
      expect(user.patient.weight_in_pounds).to eq '72.5 lbs'

      user.patient.weight = 72.5555555555
      expect(user.patient.weight_in_pounds).to eq '72.56 lbs'
    end

    it 'returns \"N/A\" if there isn\'t a recorded height' do
      user.patient.weight = nil
      expect(user.patient.weight_in_pounds).to eq 'N/A'
    end
  end

  describe '#green_zone_range' do
    it 'returns the range at which a user is considered to be in the yellow zone' do
      user.patient.yellow_zone_minimum = 100
      user.patient.yellow_zone_maximum = 200

      expect(user.patient.green_zone_range).to eq 'FLOW > 200'
    end
  end

  describe '#yellow_zone_range' do
    it 'returns the range at which a user is considered to be in the yellow zone' do
      user.patient.yellow_zone_minimum = 100
      user.patient.yellow_zone_maximum = 200

      expect(user.patient.yellow_zone_range).to eq '100 TO 200'
    end
  end

  describe '#red_zone_range' do
    it 'returns the range at which a user is considered to be in the yellow zone' do
      user.patient.yellow_zone_minimum = 100
      user.patient.yellow_zone_maximum = 200

      expect(user.patient.red_zone_range).to eq 'FLOW < 100'
    end
  end
end
