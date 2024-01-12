describe API::NotificationsController do
  let!(:user) { Fabricate :user, created_at: Date.current }
  let!(:notification) { Fabricate :notification, sent: true, created_at: Date.current + 1.day, patients: [user.patient] }
  let!(:read_notification) { Fabricate :notification, sent: true, created_at: Date.current + 1.day, patients: [user.patient] }
  let!(:read_notification_record) { Fabricate :read_notification_record, patient: user.patient, notification: read_notification }

  before { confirm_and_sign_in user }

  describe 'GET index' do
    specify 'Get the current user\'s unread notifications' do
      get :index, params: { unread: true }
      expect(response).to have_http_status 200
      expect(json[:notifications].length).to eq 1
      expect(json[:notifications][0]).to be_present
      expect(json[:notifications][0][:message]).to eq notification.message
    end
    
    specify 'Get the current user\'s read notifications' do
      get :index, params: { read: true }
      expect(response).to have_http_status 200
      expect(json[:notifications].length).to eq 1
      expect(json[:notifications][0]).to be_present
      expect(json[:notifications][0][:message]).to eq read_notification.message
    end
  end
end
