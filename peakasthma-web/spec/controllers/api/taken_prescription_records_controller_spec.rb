describe API::TakenPrescriptionRecordsController do
  let!(:user) { Fabricate :user }
  let!(:medication) { Fabricate :medication }
  let!(:prescription) { Fabricate :prescription, medication: medication, patient: user.patient }

  before { confirm_and_sign_in user }

  describe 'POST create' do
    specify 'Report that a prescription has been taken' do
      post :create, params: { id: prescription.id }
      expect(response).to have_http_status 200
      expect(json[:prescription]).to be_present
      expect(json[:prescription][:id]).to eq prescription.id
      expect(json[:prescription][:medication][:name]).to eq medication.name
    end
  end
end
