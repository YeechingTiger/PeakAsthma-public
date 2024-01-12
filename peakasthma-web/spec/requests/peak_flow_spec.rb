describe 'Peak flow navigation' do
  let!(:patient_user) { Fabricate :user }
  let!(:symptoms) { Fabricate.times 10, :symptom }
  let!(:peak_flows) { Fabricate.times 6, :peak_flow, patient: patient_user.patient }
  let!(:peak_flows_symptoms) { Fabricate.times 6, :peak_flow, patient: patient_user.patient, score: nil, symptoms: [symptoms.sample] }

  describe '#index' do
    before do
      confirm_and_login patient_user
      visit patients_path
      click_on(I18n.t('patient.views.buttons.view_all'))
    end
    
    it 'should display the peak flow index table, and list the peak flows for the patient' do
      expect(page).to have_selector('.peak-flow-table')
      expect(page).to have_selector('.peak-flow-table tbody tr', count: 12)
      expect(page).to have_selector('.peak-flow-table__symptom-badge[data-toggle="popover"]', count: 6)

      peak_flows.each do |peak_flow|
        expect(page).to have_content(peak_flow.score)
        expect(page).to have_content(I18n.l peak_flow.created_at)
      end
    end
  end
end