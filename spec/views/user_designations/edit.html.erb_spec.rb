require 'rails_helper'

RSpec.describe "user_designations/edit", type: :view do
  before(:each) do
    @user_designation = assign(:user_designation, UserDesignation.create!(
      name: "MyString",
      company: nil
    ))
  end

  it "renders the edit user_designation form" do
    render

    assert_select "form[action=?][method=?]", user_designation_path(@user_designation), "post" do

      assert_select "input[name=?]", "user_designation[name]"

      assert_select "input[name=?]", "user_designation[company_id]"
    end
  end
end
