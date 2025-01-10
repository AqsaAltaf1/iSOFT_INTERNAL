# frozen_string_literal: true

FactoryBot.define do
  factory :history do
    given_date { Date.today }
    return_date { Date.today + 1 }
    assigned_by { Faker::Name.name }
    user
    company
    company_asset
  end
end
