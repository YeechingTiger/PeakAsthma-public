Fabricator(:guardian) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name  }
  email { sequence(:email) { |i| "guardian_#{Faker::Internet.user_name}_#{i}@example.com" } }
  phone { Faker::PhoneNumber.phone_number }
  relationship_to_patient { Guardian.relationship_to_patients[Guardian.relationship_to_patients.keys.sample] }
end