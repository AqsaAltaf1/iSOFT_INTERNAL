require 'rails_helper'

RSpec.describe "employee_groups/index", type: :view do
  before(:each) do
    assign(:employee_groups, [
      EmployeeGroup.create!(
        code: "",
        name: "Name",
        description: "MyText",
        company: nil
      ),
      EmployeeGroup.create!(
        code: "",
        name: "Name",
        description: "MyText",
        company: nil
      )
    ])
  end

  it "renders a list of employee_groups" do
    render
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
