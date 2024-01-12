Fabricator(:user) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name  }
  username { sequence(:username) { |i| "user#{i}" } }
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password { 'password1' }
  role { User.roles[:patient] }
  patient_attributes { Fabricate.attributes_for(:patient) }
end
