# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'roles/new', type: :view do
  before(:each) do
    assign(:role, Role.new(
                           name: 'MyString',
                           company: nil
                         ))
  end

  it 'renders new role form' do
    render

    assert_select 'form[action=?][method=?]', roles_path, 'post' do
      assert_select 'input[name=?]', 'role[name]'

      assert_select 'input[name=?]', 'role[company_id]'
    end
  end
end
