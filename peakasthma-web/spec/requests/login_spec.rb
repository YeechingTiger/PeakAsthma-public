describe 'User login' do
  let(:user) { Fabricate :user }

  before do
    visit new_user_session_path
  end

  context 'valid credentials' do
    before do
      user.confirm
    end

    it 'shows the login page when not logged in' do
      expect(page).to have_field 'user[username]'
      expect(page).to have_field 'user[password]'
    end

    it 'allows the user to login' do
      login user
      expect(page).to have_link I18n.translate('devise.sessions.log_out'), href: destroy_user_session_path
      expect(current_path).to eq root_path
    end

    it 'shows a successful message after logging in' do
      login user
      expect(page).to have_css '.alert-notice'
      expect(page).to have_content 'Signed in successfully.'
    end
  end

  context 'invalid credentials' do
    before do
      user.confirm
    end

    it 'does not log the user in' do
      login user, 'incorrect'
      expect(page).to_not have_link I18n.translate('devise.sessions.log_out')
      expect(current_path).to eq new_user_session_path
    end

    it 'shows a failure message when failing to login' do
      login user, 'incorrect'
      expect(current_path).to eq new_user_session_path
      expect(page).to_not have_content 'Signed in successfully.'
      expect(page).to have_css '.alert-alert'
    end
  end

  context 'not confirmed' do
    it 'does not log the user in' do
      login user, 'incorrect'
      expect(page).to_not have_link I18n.translate('devise.sessions.log_out')
      expect(current_path).to eq new_user_session_path
    end

    it 'shows a failure message when failing to login' do
      login user, 'incorrect'
      expect(current_path).to eq new_user_session_path
      expect(page).to_not have_content 'Signed in successfully.'
      expect(page).to have_css '.alert-alert'
    end
  end

  def login(user, password = 'password1')
    visit new_user_session_path
    fill_in 'user[username]', with: user.username
    fill_in 'user[password]', with: password
    find('.page-content .new_user input[type=submit]').click
  end
end
