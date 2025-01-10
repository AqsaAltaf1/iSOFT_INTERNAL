require 'rails_helper'

RSpec.describe "locations/show", type: :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      work_location: "Work Location",
      country: "Country",
      state: "State",
      city: "City",
      zip_code: "Zip Code",
      address: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Work Location/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Zip Code/)
    expect(rendered).to match(/MyText/)
  end
end
