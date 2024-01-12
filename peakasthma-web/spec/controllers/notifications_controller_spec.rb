RSpec.describe NotificationsController do
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:patient_user) { Fabricate :user }
  let!(:notifications) { Fabricate.times 10, :notification }
  let!(:notification_params) { Fabricate.attributes_for :notification }
  let!(:sent_notification) { Fabricate :notification, sent: true, patients: [patient_user.patient] }

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
        get :edit, params: { id: notifications.last.id }
        expect(response).to have_http_status(:ok)
      end

      it 'will not let you edit an already sent notification' do
        get :edit, params: { id: sent_notification.id }
        expect(flash[:error]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to notifications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :edit, params: { id: notifications.last.id }
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
        post :create, params: { notification: notification_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to notifications_path
      end

      it 'will redirect to root and return an error if invalid params' do
        post :create, params: { notification: { message: 'Message, but no send time' } }
        expect(flash[:error]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to notifications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :create, params: { notification: notification_params }
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
        post :update, params: { id: notifications.last.id, notification: notification_params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to notifications_path
      end

      it 'will not let you update an already sent notification' do
        post :update, params: { id: sent_notification.id, notification: notification_params }
        expect(flash[:error]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to notifications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        post :update, params: { id: notifications.last.id, notification: notification_params }
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
        delete :destroy, params: { id: notifications.last.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to notifications_path
      end
    end

    context 'patient user' do
      before do
        confirm_and_sign_in patient_user
      end

      it 'redirects the user to root' do
        get :destroy, params: { id: notifications.last.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
      end
    end
  end
end