# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'supports/new', type: :view do
  before(:each) do
    assign(:support, Support.new(
                       subject: 'MyString',
                       email: 'MyString',
                       description: 'MyText',
                       user: nil
                     ))
  end

  it 'renders new support form' do
    render

    assert_select 'form[action=?][method=?]', supports_path, 'post' do
      assert_select 'input[name=?]', 'support[subject]'

      assert_select 'input[name=?]', 'support[email]'

      assert_select 'textarea[name=?]', 'support[description]'

      assert_select 'input[name=?]', 'support[user_id]'
    end
  end
end
