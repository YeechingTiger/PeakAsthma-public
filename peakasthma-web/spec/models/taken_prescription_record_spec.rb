RSpec.describe TakenPrescriptionRecord do
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:prescription) }
end
