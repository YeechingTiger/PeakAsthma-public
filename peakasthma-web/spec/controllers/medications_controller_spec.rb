RSpec.describe MedicationsController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:medications) { Fabricate.times 10, :medication }
  let!(:medication_params) { Fabricate.attributes_for :medication }

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
        get :show, params: { id: medications.last.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :show, params: { id: medications.last.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #update' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        post :update, params: { id: medications.last.id, medication: medication_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to medications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :update, params: { id: medications.last.id, medication: medication_params }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DEL #destroy' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        delete :destroy, params: { id: medications.last.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to medications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :destroy, params: { id: medications.last.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end