describe 'User sign-up' do
  let(:user) { Fabricate :user }

  before do
    visit new_user_registration_path
  end

  context 'valid username and password' do
    it 'shows the login page when not logged in' do
      expect(page).to have_field 'user[username]'
      expect(page).to have_field 'user[password]'
    end

    it 'allows the user to sign up and takes the user back to the login page' do
      signup "#{Faker::Internet.user_name}", 'metova123'
      expect(page).to have_field 'user[username]'
      expect(page).to have_field 'user[password]'
    end
  end

  context 'invalid username and password' do
    it 'shows an error message' do
      signup user.username, 'metova'
      expect(page).to have_content('has already been taken')
      expect(page).to have_content('6 characters minimum')
    end
  end

  def signup(username, password)
    visit new_user_registration_path
    fill_in 'user[username]', with: username
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    find('.page-content .new_user input[type=submit]').click
  end
end
