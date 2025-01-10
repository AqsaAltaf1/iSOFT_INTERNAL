require 'rails_helper'

RSpec.describe "employee_groups/show", type: :view do
  before(:each) do
    @employee_group = assign(:employee_group, EmployeeGroup.create!(
      code: "",
      name: "Name",
      description: "MyText",
      company: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
