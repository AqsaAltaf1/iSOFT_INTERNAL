require 'rails_helper'

RSpec.describe "shifts/new", type: :view do
  before(:each) do
    assign(:shift, Shift.new(
      name: "MyString",
      working_hours: 1,
      working_days: "MyText"
    ))
  end

  it "renders new shift form" do
    render

    assert_select "form[action=?][method=?]", shifts_path, "post" do

      assert_select "input[name=?]", "shift[name]"

      assert_select "input[name=?]", "shift[working_hours]"

      assert_select "textarea[name=?]", "shift[working_days]"
    end
  end
end
