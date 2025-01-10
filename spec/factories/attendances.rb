FactoryBot.define do
  factory :attendance do
    check_in { "2024-03-08 10:12:31" }
    check_out { "2024-03-08 10:12:31" }
    user { nil }
    company { nil }
  end
end
