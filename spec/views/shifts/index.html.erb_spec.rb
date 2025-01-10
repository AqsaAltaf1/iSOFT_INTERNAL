require 'rails_helper'

RSpec.describe "shifts/index", type: :view do
  before(:each) do
    assign(:shifts, [
      Shift.create!(
        name: "Name",
        working_hours: 2,
        working_days: "MyText"
      ),
      Shift.create!(
        name: "Name",
        working_hours: 2,
        working_days: "MyText"
      )
    ])
  end

  it "renders a list of shifts" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
