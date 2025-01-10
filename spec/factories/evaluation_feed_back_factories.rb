# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation_feed_back do
    feedback { Faker::Name.name }
    user
    evaluation
    evaluation_option
  end
end
