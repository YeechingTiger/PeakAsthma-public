describe 'User navigation' do
  let!(:patient_users) { Fabricate.times 20, :user }
  let!(:patient_user) { patient_users.first }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }

  describe 'User access' do
    describe 'Non-admin user' do
      before do
        confirm_and_login patient_user
        visit root_path
      end

      it 'should display the current user\'s patient details' do
        expect(page).to have_selector('.patient-profile')
        expect(page).to have_content(patient_user.patient.full_name)
        expect(page).to have_content(patient_user.patient.birthday)
        expect(page).to have_content(patient_user.patient.height_in_feet)
        expect(page).to have_content(patient_user.patient.weight_in_pounds)
        expect(page).to have_content(patient_user.patient.gender)

        expect(page).to have_content(patient_user.email)
        expect(page).to have_content(patient_user.username)
        expect(page).to have_content(patient_user.patient.phone)
        expect(page).to have_content(patient_user.patient.physician)
        expect(page).to have_content(patient_user.patient.created_at)
        expect(page).to have_content(patient_user.patient.yellow_zone_range)
      end
    end

    describe 'Admin user' do
      before do
        confirm_and_login admin
        visit root_path
      end

      it 'should display the patient index table with the 10 most recent entries for patients only' do
        expect(page).to have_selector('#patient-index-table')
        expect(page).to have_selector('#patient-index-table tbody tr', count: 10)
        expect(page).to have_selector('.mobile-asthma-statistic', count: 4)
      end
    end
  end

end