describe 'User navigation' do
  let (:user) { Fabricate :user }
  let (:admin) { Fabricate :user, role: User.roles[:admin] }

  describe 'Non-admin user navigation' do
    before do
      confirm_and_login user
      visit root_path
    end

    it 'should not display the sidebar navigation, or it\'s toggle controls' do
      expect(page.current_path).to eq root_path
      expect(page).to_not have_selector('#sidebar-wrapper')
      expect(page).to_not have_selector('.nav-drawer')
      expect(page).to_not have_selector('.asthma-page-header button.asthma-page-header__button .glyphicon-menu-hamburger')
    end

    it 'displays a link to the root in the header' do
      expect(page).to have_selector('.asthma-page-header #patient-root-navigation')
      click_link('patient-root-navigation')
      expect(page.current_path).to eq root_path
    end
  end

  describe 'Admin user navigation' do
    before do
      confirm_and_login admin
      visit root_path
    end

    it 'should display the sidebar navigation, and it\'s toggle controls' do
      expect(page.current_path).to eq root_path
      expect(page).to have_selector('#sidebar-wrapper')
      expect(page).to have_selector('.nav-drawer')
      expect(page).to have_selector('.asthma-page-header button.asthma-page-header__button .glyphicon-menu-hamburger')
    end
  end

  describe 'user account controls' do
    context 'logged in' do
      before do
        confirm_and_login user
        visit root_path
      end

      it 'should show the user account control with a button linking to the login page' do
        expect(page).to have_selector('.asthma-page-header .user-account-controls');
        expect(page).to have_selector('.user-account-controls .user-account-controls__button');
        expect(page).to have_selector('.user-account-controls__button .user-account-controls__down-indicator');
        expect(page).to have_selector('.user-account-controls__button .user-account-controls__name', text: user.last_name_first_initial);
        expect(page).to have_selector(:link_or_button, I18n.translate('devise.sessions.log_out'));
      end
    end
  end

end