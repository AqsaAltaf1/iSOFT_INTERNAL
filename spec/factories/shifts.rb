FactoryBot.define do
  factory :shift do
    name { "MyString" }
    working_hours { 1 }
    start_time { "2024-02-12 14:32:28" }
    end_time { "2024-02-12 14:32:28" }
    working_days { "MyText" }
  end
end
