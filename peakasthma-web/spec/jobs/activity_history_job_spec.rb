RSpec.describe ActivityHistoryJob, type: :job do
  let!(:user) { Fabricate :user }
  let!(:peak_flow) { Fabricate :peak_flow, patient: user.patient }

  it 'creates a new notification with a peak_flow model' do
    res = ActivityHistoryJob.perform_now peak_flow

    expect(res.subject).to eq peak_flow
    expect(res.patient).to eq peak_flow.patient
  end
end
