Fabricator(:patient) do
  gender { Patient::GENDERS.sample }
  birthday { Date.current - 12.years }
  height { Faker::Number.number(2) }
  weight { Faker::Number.decimal(3, 2) }
  phone { Faker::PhoneNumber.phone_number }
end
