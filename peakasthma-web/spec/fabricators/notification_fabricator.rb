Fabricator(:notification) do
  send_at { DateTime.current + 30.minutes }
  sent { false }
  message { Faker::WorldOfWarcraft.quote }
  author { Fabricate :user, role: :admin }
  alert { false }
end
