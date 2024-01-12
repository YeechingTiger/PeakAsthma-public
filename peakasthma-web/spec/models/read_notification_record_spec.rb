RSpec.describe ReadNotificationRecord do
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:notification) }
end
