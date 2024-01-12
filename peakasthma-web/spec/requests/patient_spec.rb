describe 'User navigation' do
  let!(:patient_users) { Fabricate.times 10, :user }
  let!(:patient_user) { Fabricate :user }
  let!(:medications) { Fabricate.times 10, :medication }
  let!(:symptoms) { Fabricate.times 10, :symptom }
  let!(:patient_user_medications) { Fabricate.times 3, :prescription, patient: patient_user.patient, medication: medications.sample }
  let!(:peak_flows) { Fabricate.times 10, :peak_flow, patient: patient_user.patient }
  let!(:peak_flows_symptoms) { Fabricate.times 10, :peak_flow, patient: patient_user.patient, score: nil, symptoms: [symptoms.sample] }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }

  describe 'Patient list' do
    describe 'Non-admin user' do
      before do
        confirm_and_login patient_user
        visit patients_path
      end

      it 'should not display the page, should redirect the user' do
        expect(page).to_not have_selector('#patient-index-table')
        expect(page.current_path).to_not eq patients_path
      end
    end

    describe 'Admin user' do
      before do
        confirm_and_login admin
        visit patients_path
      end

      it 'should display the patient index table, and list the patients' do
        expect(page).to have_selector('#patient-index-table')
        expect(page).to have_content(patient_users.first.full_name)
        expect(page).to have_content(patient_users.last.full_name)
      end

      it 'clicking on a user\'s name will take them to that patient\'s profile.' do
        click_link(patient_users.first.full_name)
        expect(page.current_path).to eq patient_path(patient_users.first.patient)
      end
    end
  end

  describe 'Patient create' do
    describe 'Non-admin user' do
      before do
        confirm_and_login patient_user
        visit new_patient_path
      end

      it 'should not display the page, should redirect the user' do
        expect(page).to_not have_selector('#patient-index-table')
        expect(page.current_path).to_not eq patients_path
      end
    end

    describe 'Admin user navigation' do
      before do
        confirm_and_login admin
        visit patients_path
      end

      it 'allows navigation from the index page to the new patient path' do
        click_on(I18n.t('patient.views.buttons.create'))
        expect(page.current_path).to eq new_patient_path
      end
    end

    describe 'Admin user creation' do
      before do
        confirm_and_login admin
        visit new_patient_path
      end

      it 'allows creation of a new patient and user' do
        fill_in('patient_user_attributes_username', with: 'testaccount')
        fill_in('patient_user_attributes_first_name', with: 'Test')
        fill_in('patient_user_attributes_last_name', with: 'McTest')
        fill_in('patient_user_attributes_email', with: 'McTest@Test.Test')
        select('male', from: 'patient_gender')
        fill_in('patient_birthday', with: Date.current)
        find('input[type=submit]').click

        expect(page.current_path).to eq patient_path(Patient.last)
        expect(page).to have_content 'Test McTest'
        expect(User.last.full_name).to eq 'Test McTest'
      end
    end
  end

  describe 'Patient update' do
    describe 'Non-admin user' do
      before do
        confirm_and_login patient_user
        visit edit_patient_path(patient_user.patient)
      end

      it 'should not display the page, should redirect the user' do
        expect(page).to_not have_selector('#patient-index-table')
        expect(page.current_path).to_not eq patients_path
      end
    end

    describe 'Admin user creation' do
      before do
        confirm_and_login admin
        visit edit_patient_path(patient_user.patient)
      end

      it 'allows editing of a the patient and user fields' do
        fill_in('patient_user_attributes_first_name', with: 'Update Test')
        fill_in('patient_user_attributes_last_name', with: 'McTest2')
        fill_in('patient_user_attributes_email', with: 'McTest2@Test.Test')
        find('input[type=submit]').click

        expect(page.current_path).to eq patient_path(patient_user.patient)
        expect(page).to have_content 'Update Test McTest2'
        expect(page).to have_content 'McTest2@Test.Test'
      end
    end
  end

  describe 'Patient detail' do
    describe 'Non-admin user' do
      before do
        confirm_and_login patient_user
        visit patient_path(patient_user.patient)
      end

      it 'should redirect the user to the root route' do
        expect(page.current_path).to eq root_path
      end

      it 'shows the patient\'s personal details' do
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

        expect(page).to have_content(patient_user.patient.green_zone_range)
        expect(page).to have_content(patient_user.patient.yellow_zone_range)
        expect(page).to have_content(patient_user.patient.red_zone_range)
      end

      it 'presents the user with the patient\'s medications in tables' do
        patient_user.patient.prescriptions.each do |prescription|
          expect(page).to have_content(prescription.medication.name)
          expect(page).to have_content(I18n.t("medication.model.routes.#{prescription.medication.route}"))
        end
        expect(page).to_not have_link(I18n.t('prescription.views.buttons.create'), href: new_patient_prescription_path(patient_user.patient))
      end

      it 'presents the user with their peak flow history' do
        expect(page).to have_selector('.peak-flow-table')
        expect(page).to have_selector('.peak-flow-table tbody tr', count: 10)
        expect(page).to have_link(I18n.t('patient.views.buttons.view_all'), href: patient_peak_flows_path(patient_user.patient))
      end
    end

    describe 'Admin user' do
      before do
        confirm_and_login admin
        visit patient_path(patient_user.patient)
      end

      it 'shows the patient\'s personal details' do
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

        expect(page).to have_content(patient_user.patient.green_zone_range)
        expect(page).to have_content(patient_user.patient.yellow_zone_range)
        expect(page).to have_content(patient_user.patient.red_zone_range)
      end

      it 'presents the user with the patient\'s medications in tables' do
        patient_user.patient.prescriptions.each do |prescription|
          expect(page).to have_content(prescription.medication.name)
          expect(page).to have_content(I18n.t("medication.model.routes.#{prescription.medication.route}"))
        end
        expect(page).to have_link(I18n.t('prescription.views.buttons.create'), href: new_patient_prescription_path(patient_user.patient))
      end
    end
  end

end