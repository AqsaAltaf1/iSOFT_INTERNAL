# frozen_string_literal: true

include ActionDispatch::TestProcess::FixtureFile
FactoryBot.define do
  factory :user do
    first_name  { Faker::Name.name }
    last_name { Faker::Name.name }
    phone_number { "+923#{Faker::PhoneNumber.subscriber_number(length: 9)}" }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    user_type { User.user_types.keys.sample }
    joining_date { Faker::Date.forward(days: 2) }
    avatar { Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png') }
    company
    role
  end
end
