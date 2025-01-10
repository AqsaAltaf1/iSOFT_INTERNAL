# frozen_string_literal: true

FactoryBot.define do
  factory :apply_leave do
    company
    allowed_leave_type { Faker::Name.name }
    allowed_day { Faker::Number.within(range: 10..15) }
    trait :short do
      company
      allowed_leave_type { 'short' }
      allowed_day { Faker::Number.within(range: 5..10) }
    end
  end
  factory :short_leave, class: ApplyLeave do
    company
    allowed_leave_type { 'short' }
    allowed_day { Faker::Number.within(range: 5..10) }
  end
end
