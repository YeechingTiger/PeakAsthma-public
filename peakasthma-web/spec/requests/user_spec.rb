describe 'Users' do
  let!(:patient_user) { Fabricate :user }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:admin2) { Fabricate :user, role: User.roles[:admin] }

  describe 'Limited to admin access' do
    context 'Non-admin user' do
      it 'should not display the page, should redirect the user' do
        confirm_and_login patient_user

        visit users_path
        expect(page).to_not have_selector('#users-index-table')
        expect(page.current_path).to_not eq users_path

        visit new_user_path
        expect(page).to_not have_selector('#users-index-table')
        expect(page.current_path).to_not eq new_user_path

        visit edit_user_path(patient_user)
        expect(page).to_not have_selector('#users-index-table')
        expect(page.current_path).to_not eq edit_user_path(patient_user)
      end
    end
  end

  context 'admin access' do
    before do
      confirm_and_login admin
      visit users_path
    end

    describe '#index' do
      it 'should display the user index table, and list the admin users' do
        expect(page).to have_selector('#users-index-table')
        expect(page).to have_content admin.full_name
        expect(page).to have_content admin2.full_name
        expect(page).not_to have_content patient_user.full_name
      end

      it 'clicking on a users\'s name will take them to that user\'s edit page.' do
        click_link(admin.full_name)
        expect(page.current_path).to eq edit_user_path(admin)
      end
    end

    describe '#create_admin' do
      it 'navigates to the new user view, accepts params, and creates a new user' do
        click_link(I18n.t('user.views.buttons.create'))
        fill_in('user_username', with: 'testaccount')
        fill_in('user_first_name', with: 'Test')
        fill_in('user_last_name', with: 'McTest')
        fill_in('user_email', with: 'McTest@Test.Test')
        fill_in('user_password', with: 'password1')
        find('input[type=submit]').click

        expect(page).to have_content 'Test McTest'
        expect(User.last.full_name).to eq 'Test McTest'
      end
    end

    describe '#update' do
      it 'navigates to the new user view, accepts params, and updates a user' do
        click_link(admin.full_name)
        fill_in('user_first_name', with: 'Kevin')
        fill_in('user_last_name', with: 'McKevin')
        find('input[type=submit]').click

        expect(page).to have_content 'Kevin McKevin'
      end
    end

    describe '#delete' do
      it 'deletes the model when clicking the delete icon' do
        expect { click_link("#{admin2.id}_delete") }.to change(User, :count).by(-1)
      end
    end
  end

end