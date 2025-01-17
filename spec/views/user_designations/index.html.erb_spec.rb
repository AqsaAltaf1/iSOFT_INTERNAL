require 'rails_helper'

RSpec.describe "user_designations/index", type: :view do
  before(:each) do
    assign(:user_designations, [
      UserDesignation.create!(
        name: "Name",
        company: nil
      ),
      UserDesignation.create!(
        name: "Name",
        company: nil
      )
    ])
  end

  it "renders a list of user_designations" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
