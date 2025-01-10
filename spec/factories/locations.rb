FactoryBot.define do
  factory :location do
    work_location { "MyString" }
    country { "MyString" }
    state { "MyString" }
    city { "MyString" }
    zip_code { "MyString" }
    address { "MyText" }
  end
end
