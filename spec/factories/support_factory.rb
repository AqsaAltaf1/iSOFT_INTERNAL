# frozen_string_literal: true

FactoryBot.define do
  factory :support do
    subject { Faker::Name.name }
    email { Faker::Internet.email }
    description { Faker::String.random(length: 3..12) }
    user
    company
  end
end
