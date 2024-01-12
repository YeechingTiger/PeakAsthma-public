RSpec.describe Prescription do
  it { is_expected.to validate_presence_of :frequency }
end
