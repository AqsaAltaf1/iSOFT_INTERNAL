# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    question { Faker::Name.name }
    question_type { Question.question_types.keys.sample }
    company
    evaluation
  end
end
