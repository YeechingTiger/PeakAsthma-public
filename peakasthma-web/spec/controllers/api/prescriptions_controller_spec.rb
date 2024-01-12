describe API::PrescriptionsController do
  let!(:user) { Fabricate :user }
  let!(:medication) { Fabricate :medication }
  let!(:prescription) { Fabricate :prescription, medication: medication, patient: user.patient }

  before { confirm_and_sign_in user }

  describe 'GET index' do
    specify 'Get the current user\'s medications' do
      get :index
      expect(response).to have_http_status 200
      expect(json[:prescriptions].length).to eq 1
      expect(json[:prescriptions][0][:frequency]).to be_present
      expect(json[:prescriptions][0][:medication]).to be_present
      expect(json[:prescriptions][0][:medication][:name]).to be_present
      expect(json[:prescriptions][0][:medication][:route]).to be_present
    end
  end
end
