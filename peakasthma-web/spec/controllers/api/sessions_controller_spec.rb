describe API::SessionsController do
  let!(:user) { Fabricate :user }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:api_user]
  end

  describe 'POST create' do
    specify 'Login without verifying email' do
      post :create, params: { user: { username: user.username, password: user.password } }
      expect(response).to have_http_status 401
      expect(json[:errors]).to include 'You have to confirm your email address before continuing.'
    end

    specify 'Login and get the user data, and set the user\'s used_mobile_app flag'  do
      user.confirm
      expect(User.last.used_mobile_app).to eq false

      post :create, params: { user: { username: user.username, password: user.password } }
      expect(response).to have_http_status 200
      expect(User.last.used_mobile_app).to eq true

      expect(json[:user][:username]).to eq user.username
      expect(json[:user][:id]).to eq user.id
      expect(json[:user][:authentication_token]).to eq user.authentication_token
      expect(json[:user][:first_name]).to eq user.first_name
      expect(json[:user][:last_name]).to eq user.last_name
      expect(json[:user][:birthday]).to eq user.patient.birthday.to_s
      expect(json[:user][:gender]).to eq user.patient.gender
      expect(json[:user][:first_time_login]).to eq true
    end

    specify 'Login with wrong password' do
      post :create, params: { user: { username: user.username, password: 'incorrect' } }
      expect(response).to have_http_status 401
      expect(json[:errors]).to include 'Invalid Username or password.'
    end
  end
end
