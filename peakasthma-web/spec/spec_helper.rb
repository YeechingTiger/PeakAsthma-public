ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require File.expand_path('../support/simplecov', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'avocado/rspec'
require 'rspec/rails'

require 'webmock/rspec'
require 'shoulda/matchers'
require 'sidekiq/testing'

WebMock.disable_net_connect! allow_localhost: true

ActiveRecord::Migration.maintain_test_schema!

Sidekiq::Testing.fake!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.order = :random
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.render_views = true
  config.global_fixtures = :all
  config.fixture_path = Rails.root.join('spec', 'fixtures')
  config.include Devise::Test::ControllerHelpers, type: :controller
end

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, /fcm.googleapis.com/).
      with(headers: {'Content-Type': 'application/json', 'Authorization': "key=#{Rails.application.secrets.fb_key}"}).
      to_return(status: 200, body: "stubbed response", headers: {})
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

def confirm_and_sign_in(user)
  @request.env['devise.mapping'] = Devise.mappings[:api_user]
  user.confirm
  sign_in user
end

def confirm_and_login(user, password = 'password1')
  visit new_user_session_path
  user.confirm
  fill_in 'user[username]', with: user.username
  fill_in 'user[password]', with: password
  find('.page-content .new_user input[type=submit]').click
end

def logout
  click_link 'Logout'
end

