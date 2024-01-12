Fabricator(:prescription) do
  medication
  frequency { Prescription::ALL_FREQUENCIES.sample }
  unit { Prescription::ALL_UNITS.sample }
  quantity { Faker::Number.number(2) }
end
