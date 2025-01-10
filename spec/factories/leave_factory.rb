# frozen_string_literal: true

FactoryBot.define do
  factory :leave do
    user
    company
    apply_leave
    request_leaves { Faker::Number.within(range: 1..4) }
    sequence(:date_from) { |n| Date.today + n }
    sequence(:date_to) { |n| Date.today + n + 1 }
    trait :short_leave do
      association :apply_leave, factory: :short_leave
      short_type { Leave.short_types.keys.sample }
      date_from { Date.today }
      date_to { Date.today }
    end
  end
end
