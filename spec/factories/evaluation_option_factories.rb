# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation_option do
    option { Faker::Name.name }
    question
  end
end
