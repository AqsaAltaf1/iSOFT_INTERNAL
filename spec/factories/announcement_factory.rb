# frozen_string_literal: true

FactoryBot.define do
  factory :announcement do
    title { Faker::Name.name }
    body { Faker::Company.catch_phrase }
    company
  end
end
