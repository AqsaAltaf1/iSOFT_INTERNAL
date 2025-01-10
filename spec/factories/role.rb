# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'hr' }
    company_id { nil }
    before(:create) do |role|
      role.permissions << FactoryBot.create(:permission)
    end
  end
end
