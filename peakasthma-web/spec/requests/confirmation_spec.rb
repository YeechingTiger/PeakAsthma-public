# Devise.token_generator.digest(self, :confirmation_token, confirmation_token)

describe 'User confirmation' do
  let!(:patient_user) { Fabricate :user }

  describe 'Non-admin user' do
    before do
      visit user_confirmation_path(confirmation_token: patient_user.confirmation_token)
    end

    it 'displays the confirmation page for the user, with a password and confirm password field' do
      expect(page).to have_selector('.sign-in')
      expect(page).to have_selector('input[name="user[password]"]')
      expect(page).to have_selector('input[name="user[password_confirmation]"]')
    end

    it 'allows the user to set their password and confirm, then takes them to their profile page' do
      fill_in('user_password', with: 'password1')
      fill_in('user_password_confirmation', with: 'password1')
      find('input[type=submit]').click

      expect(User.last.confirmed?).to eq true
      expect(page.current_path).to eq root_path
    end

    it 'allows the user to set their password and confirm, but only if they match' do
      fill_in('user_password', with: 'password1')
      fill_in('user_password_confirmation', with: 'passwordUnmatching')
      find('input[type=submit]').click

      expect(User.last.confirmed?).to eq false
    end
  end

end