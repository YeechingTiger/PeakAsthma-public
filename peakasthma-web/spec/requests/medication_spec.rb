describe 'Medications' do
  let!(:patient_user) { Fabricate :user }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:medications) { Fabricate.times 10, :medication }

  describe 'Limited to admin access' do
    describe 'Non-admin user' do
      it 'should not display the page, should redirect the user' do
        confirm_and_login patient_user

        visit medications_path
        expect(page).to_not have_selector('#medications-index-table')
        expect(page.current_path).to_not eq medications_path

        visit new_medication_path
        expect(page).to_not have_selector('#medications-index-table')
        expect(page.current_path).to_not eq new_medication_path

        visit medication_path(medications.first)
        expect(page).to_not have_selector('#medications-index-table')
        expect(page.current_path).to_not eq medication_path(medications.first)
      end
    end
  end

  describe 'admin access' do
    before do
      confirm_and_login admin
      visit medications_path
    end

    describe '#index' do
      it 'should display the medication index table, and list the medications' do
        expect(page).to have_selector('#medications-index-table')
        medications.each do |medication|
          expect(page).to have_content medication.name
          expect(page).to have_content I18n.t("medication.model.formulations.#{medication.formulation}")
          expect(page).to have_content I18n.t("medication.model.routes.#{medication.route}")
        end
      end

      it 'clicking on a medication\'s name will take them to that medication\'s detail page.' do
        click_link(medications.first.name)
        expect(page.current_path).to eq medication_path(medications.first)
      end

      it 'accepts search terms and filters the list' do
        fill_in('search_name', with: medications.first.name)
        click_button(I18n.t('common.labels.search'))
        expect(page).to have_selector('#medications-index-table')
        expect(page).to have_content medications.first.name
        expect(page).to have_selector('tr', count: 2)
      end
    end

    describe '#create' do
      it 'navigates to the new item view, accepts params, and creates a new medication' do
        click_link(I18n.t('medication.views.buttons.create'))
        fill_in('medication_name', with: 'Dose Of Unit Testing, 10mg' )
        select(I18n.t('medication.model.routes.oral'), from: 'medication_route')
        select(I18n.t('medication.model.formulations.pill'), from: 'medication_formulation')
        find('input[type=submit]').click

        expect(Medication.last.name).to eq 'Dose Of Unit Testing, 10mg'
        expect(Medication.last.route).to eq 'oral'
        expect(Medication.last.formulation).to eq 'pill'
      end
    end

    describe '#update' do
      it 'navigates to the new item view, accepts params, and creates a new medication' do
        click_link(medications.first.name)
        fill_in('medication_name', with: 'Now the First Medication' )
        find('input[type=submit]').click

        expect(Medication.first.name).to eq 'Now the First Medication'
      end
    end

    describe '#delete' do
      it 'deletes the model when clicking the delete icon' do
        expect{ click_link("#{medications.first.id}_delete") }.to change{Medication.count}.by(-1)
      end
    end
  end

end