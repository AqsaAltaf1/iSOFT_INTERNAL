# frozen_string_literal: true

FactoryBot.define do
  factory :upcoming_holiday do
    title { Faker::Name.name }
    description { Faker::Company.catch_phrase }
    date { Faker::Date.forward(days: 2) }
    company
  end
end
