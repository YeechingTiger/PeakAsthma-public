describe API::ActivitiesController do
  let!(:user) { Fabricate :user }
  let!(:peak_flow) { Fabricate :peak_flow, patient: user.patient }
  let!(:activities) { Fabricate.times 10, :activity, patient: user.patient, subject: peak_flow }

  before { confirm_and_sign_in user }

  describe 'GET index' do
    specify 'Get the current user\'s activities' do
      get :index
      expect(response).to have_http_status 200
      expect(json[:activities].length).to eq activities.length
      expect(json[:activities][0][:peak_flow][:level]).to be_present
      expect(json[:activities][0][:peak_flow][:score]).to be_present
    end
  end
end
