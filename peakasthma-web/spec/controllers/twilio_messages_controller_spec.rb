RSpec.describe TwilioMessagesController do

  describe 'GET #reply' do
    it 'returns http success' do
      get :reply
      expect(response).to have_http_status(:success)
    end
  end
end
