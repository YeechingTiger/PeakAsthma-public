RSpec.describe Medication do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :route }
end
