require 'rails_helper'

RSpec.describe "shifts/edit", type: :view do
  before(:each) do
    @shift = assign(:shift, Shift.create!(
      name: "MyString",
      working_hours: 1,
      working_days: "MyText"
    ))
  end

  it "renders the edit shift form" do
    render

    assert_select "form[action=?][method=?]", shift_path(@shift), "post" do

      assert_select "input[name=?]", "shift[name]"

      assert_select "input[name=?]", "shift[working_hours]"

      assert_select "textarea[name=?]", "shift[working_days]"
    end
  end
end
