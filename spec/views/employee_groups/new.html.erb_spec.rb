require 'rails_helper'

RSpec.describe "employee_groups/new", type: :view do
  before(:each) do
    assign(:employee_group, EmployeeGroup.new(
      code: "",
      name: "MyString",
      description: "MyText",
      company: nil
    ))
  end

  it "renders new employee_group form" do
    render

    assert_select "form[action=?][method=?]", employee_groups_path, "post" do

      assert_select "input[name=?]", "employee_group[code]"

      assert_select "input[name=?]", "employee_group[name]"

      assert_select "textarea[name=?]", "employee_group[description]"

      assert_select "input[name=?]", "employee_group[company_id]"
    end
  end
end
