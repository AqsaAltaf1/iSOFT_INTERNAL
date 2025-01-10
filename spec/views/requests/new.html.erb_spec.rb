require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, Request.new(
      details: "",
      request_type: 1,
      user: nil,
      company: nil
    ))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do

      assert_select "input[name=?]", "request[details]"

      assert_select "input[name=?]", "request[request_type]"

      assert_select "input[name=?]", "request[user_id]"

      assert_select "input[name=?]", "request[company_id]"
    end
  end
end
