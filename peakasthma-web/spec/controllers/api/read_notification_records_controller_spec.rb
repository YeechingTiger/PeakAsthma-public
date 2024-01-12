describe API::ReadNotificationRecordsController do
  let!(:user) { Fabricate :user, created_at: Date.current }
  let!(:notification) { Fabricate :notification, sent: true, created_at: Date.current + 1.day }

  before { confirm_and_sign_in user }

  describe 'POST create' do
    specify 'Report that a notification has been read' do
      post :create, params: { id: notification.id }
      expect(response).to have_http_status 200
      expect(json[:notification]).to be_present
      expect(json[:notification][:message]).to eq notification.message
    end
  end
end
