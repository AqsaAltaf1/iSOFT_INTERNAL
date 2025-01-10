FactoryBot.define do
  factory :request do
    details { "" }
    request_type { 1 }
    user { nil }
    company { nil }
  end
end
