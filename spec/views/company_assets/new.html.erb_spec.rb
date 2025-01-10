# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'company_assets/new', type: :view do
  before(:each) do
    assign(:company_asset, CompanyAsset.new(
                             model: 'MyString',
                             type: '',
                             name: 'MyString',
                             user: nil
                           ))
  end

  it 'renders new company_asset form' do
    render

    assert_select 'form[action=?][method=?]', company_assets_path, 'post' do
      assert_select 'input[name=?]', 'company_asset[model]'

      assert_select 'input[name=?]', 'company_asset[type]'

      assert_select 'input[name=?]', 'company_asset[name]'

      assert_select 'input[name=?]', 'company_asset[user_id]'
    end
  end
end
