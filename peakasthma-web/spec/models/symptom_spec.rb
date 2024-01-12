RSpec.describe Symptom do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :level }

  it { should have_and_belong_to_many(:medications) }
  it { should have_and_belong_to_many(:peak_flows) }
end
