require 'rails_helper'

RSpec.describe "locations/new", type: :view do
  before(:each) do
    assign(:location, Location.new(
      work_location: "MyString",
      country: "MyString",
      state: "MyString",
      city: "MyString",
      zip_code: "MyString",
      address: "MyText"
    ))
  end

  it "renders new location form" do
    render

    assert_select "form[action=?][method=?]", locations_path, "post" do

      assert_select "input[name=?]", "location[work_location]"

      assert_select "input[name=?]", "location[country]"

      assert_select "input[name=?]", "location[state]"

      assert_select "input[name=?]", "location[city]"

      assert_select "input[name=?]", "location[zip_code]"

      assert_select "textarea[name=?]", "location[address]"
    end
  end
end
