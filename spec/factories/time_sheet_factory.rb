# frozen_string_literal: true

FactoryBot.define do
  factory :time_sheet do
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    date { Date.today }
    time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    project
    company
    user
  end
end
