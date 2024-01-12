describe API::RegistrationsController do
  let(:user_params) { Fabricate.attributes_for(:user) }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:api_user]
  end

  describe 'POST create' do
    specify 'Does not create a user when the patient params are missing' do
      user_params[:patient_attributes] = nil
      post :create, params: { user: user_params }
      expect(response).to have_http_status :unprocessable_entity
    end

    specify 'Create a user and patient but does not confirm them' do
      post :create, params: { user: user_params }
      expect(response).to have_http_status 201
      expect(json[:authentication_token]).to be_present
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last['to'].to_s).to eq(user_params[:email])
      expect(User.last.patient.persisted?).to eq true
    end
  end
end
