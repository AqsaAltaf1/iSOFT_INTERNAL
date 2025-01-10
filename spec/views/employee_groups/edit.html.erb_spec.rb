require 'rails_helper'

RSpec.describe "employee_groups/edit", type: :view do
  before(:each) do
    @employee_group = assign(:employee_group, EmployeeGroup.create!(
      code: "",
      name: "MyString",
      description: "MyText",
      company: nil
    ))
  end

  it "renders the edit employee_group form" do
    render

    assert_select "form[action=?][method=?]", employee_group_path(@employee_group), "post" do

      assert_select "input[name=?]", "employee_group[code]"

      assert_select "input[name=?]", "employee_group[name]"

      assert_select "textarea[name=?]", "employee_group[description]"

      assert_select "input[name=?]", "employee_group[company_id]"
    end
  end
end
