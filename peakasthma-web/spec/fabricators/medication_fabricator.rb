Fabricator(:medication) do
  name { Fabricate.sequence(:name) { |i| "#{Faker::Ancient.god}_#{i}" } }
  route { Medication::ROUTES.sample }
  formulation { Medication::FORMULATIONS.sample }
end
