Fabricator(:symptom) do
  name { Fabricate.sequence(:name) { |i| "#{Faker::Superhero.power}_#{i}" } }
  level { PeakFlow::LEVELS.sample }
end
