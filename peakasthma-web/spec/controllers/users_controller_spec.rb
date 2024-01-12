RSpec.describe UsersController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:admin_params) { Fabricate.attributes_for :user, role: User.roles[:admin] }

  describe 'GET #index' do
    it 'returns http success for admins' do
      confirm_and_sign_in admin
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'redirects a patient user' do
      confirm_and_sign_in patient_user
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET #new' do
    it 'returns http success for admins' do
      confirm_and_sign_in admin
      get :new
      expect(response).to have_http_status(:ok)
    end

    it 'redirects a patient user' do
      confirm_and_sign_in patient_user
      get :new
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET #edit' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        get :edit, params: { id: admin.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :edit, params: { id: admin.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create_admin' do
    context 'admin user' do
      before do
        confirm_and_sign_in admin
      end

      it 'returns http success for admins' do
        post :create_admin, params: { user: admin_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to users_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :create_admin, params: { user: admin_params }
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
        post :update, params: { id: admin.id, user: admin_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to users_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :update, params: { id: admin.id, user: admin_params }
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
        delete :destroy, params: { id: admin.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to users_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :destroy, params: { id: admin.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end