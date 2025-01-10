require 'rails_helper'

RSpec.describe "locations/index", type: :view do
  before(:each) do
    assign(:locations, [
      Location.create!(
        work_location: "Work Location",
        country: "Country",
        state: "State",
        city: "City",
        zip_code: "Zip Code",
        address: "MyText"
      ),
      Location.create!(
        work_location: "Work Location",
        country: "Country",
        state: "State",
        city: "City",
        zip_code: "Zip Code",
        address: "MyText"
      )
    ])
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", text: "Work Location".to_s, count: 2
    assert_select "tr>td", text: "Country".to_s, count: 2
    assert_select "tr>td", text: "State".to_s, count: 2
    assert_select "tr>td", text: "City".to_s, count: 2
    assert_select "tr>td", text: "Zip Code".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
