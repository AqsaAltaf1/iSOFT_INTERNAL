require 'rails_helper'

RSpec.describe "user_designations/new", type: :view do
  before(:each) do
    assign(:user_designation, UserDesignation.new(
      name: "MyString",
      company: nil
    ))
  end

  it "renders new user_designation form" do
    render

    assert_select "form[action=?][method=?]", user_designations_path, "post" do

      assert_select "input[name=?]", "user_designation[name]"

      assert_select "input[name=?]", "user_designation[company_id]"
    end
  end
end
