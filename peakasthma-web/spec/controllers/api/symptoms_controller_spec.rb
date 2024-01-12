describe API::SymptomsController do
  let!(:user) { Fabricate :user }
  let!(:yellow_symptoms) { Fabricate.times 10, :symptom, level: :yellow }
  let!(:red_symptoms) { Fabricate.times 15, :symptom, level: :red }

  before { confirm_and_sign_in user }

  describe 'GET index' do
    specify 'Get the full list of symptoms when a level is not present' do
      get :index
      expect(response).to have_http_status 200
      expect(json[:symptoms].length).to eq yellow_symptoms.count + red_symptoms.count
      expect(json[:symptoms][0][:name]).to be_present
      expect(json[:symptoms][0][:level]).to be_present
    end

    specify 'Get the matching list of symptoms when a level is present' do
      get :index, params: { level: :yellow }
      expect(response).to have_http_status 200
      expect(json[:symptoms].length).to eq yellow_symptoms.count
      expect(json[:symptoms][0][:name]).to be_present
      expect(json[:symptoms][0][:level]).to be_present

      get :index, params: { level: :red }
      expect(response).to have_http_status 200
      expect(json[:symptoms].length).to eq red_symptoms.count
      expect(json[:symptoms][0][:name]).to be_present
      expect(json[:symptoms][0][:level]).to be_present
    end
  end
end
