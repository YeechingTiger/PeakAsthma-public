describe API::UsersController do
  let!(:user) { Fabricate :user }
  let!(:patient) { Fabricate :patient, user: user }
  before { confirm_and_sign_in user }

  describe 'GET current' do
    specify 'Get the current user' do
      get :current
      expect(response).to have_http_status 200
      expect(json[:user]).to be_present
      expect(json[:user][:authentication_token]).to be_present
      expect(json[:user][:id]).to be_present
    end
  end
end
