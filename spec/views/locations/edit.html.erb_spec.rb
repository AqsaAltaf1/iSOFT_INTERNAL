require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      work_location: "MyString",
      country: "MyString",
      state: "MyString",
      city: "MyString",
      zip_code: "MyString",
      address: "MyText"
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input[name=?]", "location[work_location]"

      assert_select "input[name=?]", "location[country]"

      assert_select "input[name=?]", "location[state]"

      assert_select "input[name=?]", "location[city]"

      assert_select "input[name=?]", "location[zip_code]"

      assert_select "textarea[name=?]", "location[address]"
    end
  end
end
