require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    assign(:requests, [
      Request.create!(
        details: "",
        request_type: 2,
        user: nil,
        company: nil
      ),
      Request.create!(
        details: "",
        request_type: 2,
        user: nil,
        company: nil
      )
    ])
  end

  it "renders a list of requests" do
    render
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
