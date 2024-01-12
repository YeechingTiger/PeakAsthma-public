RSpec.describe SymptomsController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:symptoms) { Fabricate.times 10, :symptom }
  let!(:symptom_params) { Fabricate.attributes_for :symptom }

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

  describe 'GET #edit' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        get :edit, params: { id: symptoms.last.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :edit, params: { id: symptoms.last.id }
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
        post :update, params: { id: symptoms.last.id, symptom: symptom_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to symptoms_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :update, params: { id: symptoms.last.id, symptom: symptom_params }
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
        delete :destroy, params: { id: symptoms.last.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to symptoms_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :destroy, params: { id: symptoms.last.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end