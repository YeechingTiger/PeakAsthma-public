require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'lib/templates'
  add_filter { |src| src.filename =~ /application_(record|mailer|job|cable)/ }
end
