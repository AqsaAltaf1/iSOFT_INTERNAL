# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    name { Faker::Name.name }
    controller { Faker::Name.name }
    controller_method { 'create' }
  end
end
