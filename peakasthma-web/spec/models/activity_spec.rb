RSpec.describe Activity do
  it { should belong_to(:patient) }
  it { should belong_to(:subject) }
end
