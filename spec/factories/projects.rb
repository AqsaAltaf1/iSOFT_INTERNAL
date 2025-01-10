# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Name.name }
    description { Faker::Company.catch_phrase }
    company
    after(:create) do |project, evaluator|
      evaluator.user_ids.each do |_user_id|
        project.users << user
      end
    end
  end
end
