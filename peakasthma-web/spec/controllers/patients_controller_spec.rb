RSpec.describe PatientsController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:other_user) { Fabricate :user }

  describe 'GET #index' do
    it 'returns http success for admins' do
      confirm_and_sign_in admin
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'redirects a patient user' do
      confirm_and_sign_in patient_user
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET #show' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        get :show, params: { id: patient_user.patient.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root when visiting their own profile' do
        get :show, params: { id: patient_user.patient.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end

      it 'redirects the patient if they try to view another user' do
        get :show, params: { id: other_user.patient.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end
