# frozen_string_literal: true

FactoryBot.define do
  factory :company_asset do
    model { Faker::Name.name }
    name { Faker::Name.name }
    added_by { Faker::Name.name }
    purchase_date { Date.today }
    status { CompanyAsset.statuses.keys.sample }
    unique_identifier { Faker::Alphanumeric.alpha(number: 10) }
    company
    user
    trait :invalid_file do
      name { Faker::Name.name }
      company
      user
      after(:build) do |company_asset|
        company_asset.images.attach(
          Rack::Test::UploadedFile.new('spec/fixtures/no-image.zip')
        )
      end
    end
  end
end
