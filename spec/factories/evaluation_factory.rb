# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation do
    title { Faker::Name.name }
    status { Evaluation.statuses.keys.sample }
    company
    transient do
      questions_count { 1 }
    end

    after(:build) do |evaluation, evaluator|
      evaluation.questions = build_list(:question, evaluator.questions_count, evaluation_id: evaluation.id,
                                                                              company_id: evaluation.company_id)
    end
  end
end
