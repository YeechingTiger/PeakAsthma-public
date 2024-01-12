RSpec.describe PrescriptionsController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:medications) { Fabricate.times 10, :medication }
  let!(:prescription) { Fabricate :prescription, patient: patient_user.patient }
  let!(:prescription_params) { Fabricate.attributes_for :prescription }

  describe 'GET #new' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        get :new, params: { patient_id: patient_user.patient }
        expect(response).to have_http_status(:success)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :new, params: { patient_id: patient_user.patient }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        post :create, params: { patient_id: patient_user.patient, prescription: prescription_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to patient_path(patient_user.patient)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :create, params: { patient_id: patient_user.patient, prescription: prescription_params }
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
        post :update, params: { patient_id: patient_user.patient, id: prescription.id, prescription: prescription_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to patient_path(patient_user.patient)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :update, params: { patient_id: patient_user.patient, id: prescription.id, prescription: prescription_params }
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
        delete :destroy, params: { patient_id: patient_user.patient, id: prescription.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to patient_path(patient_user.patient)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :destroy, params: { patient_id: patient_user.patient, id: prescription.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end