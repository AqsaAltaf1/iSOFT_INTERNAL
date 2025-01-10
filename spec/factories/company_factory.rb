# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    status { Company.statuses.keys.sample }
    subdomain { Faker::Internet.domain_word + rand(100..999).to_s }
    avatar { Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png') }
  end
end
