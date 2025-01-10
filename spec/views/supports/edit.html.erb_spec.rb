# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'supports/edit', type: :view do
  before(:each) do
    @support = assign(:support, Support.create!(
                                  subject: 'MyString',
                                  email: 'MyString',
                                  description: 'MyText',
                                  user: nil
                                ))
  end

  it 'renders the edit support form' do
    render

    assert_select 'form[action=?][method=?]', support_path(@support), 'post' do
      assert_select 'input[name=?]', 'support[subject]'

      assert_select 'input[name=?]', 'support[email]'

      assert_select 'textarea[name=?]', 'support[description]'

      assert_select 'input[name=?]', 'support[user_id]'
    end
  end
end
