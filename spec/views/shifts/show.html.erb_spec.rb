require 'rails_helper'

RSpec.describe "shifts/show", type: :view do
  before(:each) do
    @shift = assign(:shift, Shift.create!(
      name: "Name",
      working_hours: 2,
      working_days: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end
