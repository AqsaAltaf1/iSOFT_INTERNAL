# frozen_string_literal: true

FactoryBot.define do
  factory :help_document do
    name { Faker::Name.name }
    file { Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png') }
    company
  end
end
