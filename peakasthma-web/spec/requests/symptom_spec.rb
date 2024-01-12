describe 'Symptoms' do
  let!(:patient_user) { Fabricate :user }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:symptoms) { Fabricate.times 10, :symptom }

  describe 'Limited to admin access' do
    describe 'Non-admin user' do
      it 'should not display the page, should redirect the user' do
        confirm_and_login patient_user

        visit symptoms_path
        expect(page).to_not have_selector('#symptoms-index-table')
        expect(page.current_path).to_not eq symptoms_path

        visit new_symptom_path
        expect(page).to_not have_selector('#symptoms-index-table')
        expect(page.current_path).to_not eq new_symptom_path

        visit edit_symptom_path(symptoms.first)
        expect(page).to_not have_selector('#symptoms-index-table')
        expect(page.current_path).to_not eq edit_symptom_path(symptoms.first)
      end
    end
  end

  describe 'admin access' do
    before do
      confirm_and_login admin
      visit symptoms_path
    end

    describe '#index' do
      it 'should display the symptom index table, and list the symptoms' do
        expect(page).to have_selector('#symptoms-index-table')
        symptoms.each do |symptom|
          expect(page).to have_content symptom.name
          expect(page).to have_selector "\#symptom-#{symptom.id} .symptoms-index-table__level--#{symptom.level}"
        end
      end

      it 'clicking on a symptom\'s name will take them to that symptom\'s edit page.' do
        click_link(symptoms.first.name)
        expect(page.current_path).to eq edit_symptom_path(symptoms.first)
      end
    end

    describe '#create' do
      it 'navigates to the new item view, accepts params, and creates a new symptom' do
        click_link(I18n.t('symptom.views.buttons.create'))
        fill_in('symptom_name', with: 'Unit Testing Addiction' )
        select(I18n.t('symptom.model.levels.green'), from: 'symptom_level')
        find('input[type=submit]').click

        expect(Symptom.last.name).to eq 'Unit Testing Addiction'
        expect(page).to have_selector "\#symptom-#{Symptom.last.id} .symptoms-index-table__level--#{Symptom.last.level}"
      end
    end

    describe '#update' do
      it 'navigates to the new item view, accepts params, and creates a new symptom' do
        click_link(symptoms.first.name)
        fill_in('symptom_name', with: 'Now the First symptom' )
        find('input[type=submit]').click

        expect(Symptom.first.name).to eq 'Now the First symptom'
      end
    end

    describe '#delete' do
      it 'deletes the model when clicking the delete icon' do
        expect{ click_link("#{symptoms.first.id}_delete") }.to change{Symptom.count}.by(-1)
      end
    end
  end

end