describe API::PeakFlowsController do
  let!(:user) { Fabricate :user }
  let!(:green_symptom) { Fabricate :symptom, level: :green }
  let!(:yellow_symptom) { Fabricate :symptom, level: :yellow }
  let!(:red_symptom) { Fabricate :symptom, level: :red }

  let!(:medications) { Fabricate.times 2, :medication }
  let!(:yellow_prescription) { Fabricate :prescription, patient: user.patient, level: :yellow, medication: medications[0] }
  let!(:red_prescription) { Fabricate :prescription, patient: user.patient, level: :red, medication: medications[1] }

  before { confirm_and_sign_in user }

  describe 'POST create' do
    specify 'POSTs no peak-flow, creates a green report' do
      expect {
        post :create, params: { }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'green'
    end

    specify 'POSTs a green-zone peak flow value, get the expected level back' do
      expect {
        post :create, params: { score: user.patient.yellow_zone_maximum + 1 }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'green'
    end

    specify 'POSTs a yellow-zone peak flow value, get the expected level back, and the recommended medication' do
      expect {
        post :create, params: { score: user.patient.yellow_zone_minimum }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'yellow'
      expect(json[:prescription][:id]).to eq yellow_prescription.id
    end

    specify 'POSTs a red-zone peak flow value, get the expected level back, and the recommended medication' do
      expect {
        post :create, params: { score: 0 }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'red'
      expect(json[:prescription][:id]).to eq red_prescription.id
    end

    specify 'POSTS a green-zone symptom list, get the expected level back' do
      expect {
        post :create, params: { symptoms: [ green_symptom.as_json ] }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'green'
    end

    specify 'POSTS a yellow-zone symptom list, get the expected level back, and the recommended medication' do
      expect {
        post :create, params: { symptoms: [ yellow_symptom.as_json ] }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'yellow'
      expect(json[:prescription][:id]).to eq yellow_prescription.id
    end

    specify 'POSTS a red-zone symptom list, get the expected level back, and the recommended medication' do
      expect {
        post :create, params: { symptoms: [ red_symptom.as_json ] }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'red'
      expect(json[:prescription][:id]).to eq red_prescription.id
    end

    specify 'POSTS an empty symptom list, gets green zone' do
      expect {
        post :create, params: { symptoms: [ ] }
      }.to change(PeakFlow, :count).by 1
      expect(response).to have_http_status 200
      expect(json[:peak_flow][:level]).to eq 'green'
    end

    specify 'POSTS an invalid symptom list, gets an error' do
      expect {
        post :create, params: { symptoms: [ { id: Symptom.first.id - 1 } ] }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET index' do
    let!(:peak_flows) { Fabricate.times 5, :peak_flow, patient: user.patient }
    
    specify 'should get the latest 4 peak flows' do
      get :index
      expect(response).to have_http_status 200
      expect(json[:peak_flows].count).to eq 4
    end
  end
end
