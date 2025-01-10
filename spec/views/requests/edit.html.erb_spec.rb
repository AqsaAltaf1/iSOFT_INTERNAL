require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  before(:each) do
    @request = assign(:request, Request.create!(
      details: "",
      request_type: 1,
      user: nil,
      company: nil
    ))
  end

  it "renders the edit request form" do
    render

    assert_select "form[action=?][method=?]", request_path(@request), "post" do

      assert_select "input[name=?]", "request[details]"

      assert_select "input[name=?]", "request[request_type]"

      assert_select "input[name=?]", "request[user_id]"

      assert_select "input[name=?]", "request[company_id]"
    end
  end
end
