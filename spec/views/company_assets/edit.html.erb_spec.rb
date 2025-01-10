# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'company_assets/edit', type: :view do
  before(:each) do
    @company_asset = assign(:company_asset, CompanyAsset.create!(
                                              model: 'MyString',
                                              type: '',
                                              name: 'MyString',
                                              user: nil
                                            ))
  end

  it 'renders the edit company_asset form' do
    render

    assert_select 'form[action=?][method=?]', company_asset_path(@company_asset), 'post' do
      assert_select 'input[name=?]', 'company_asset[model]'

      assert_select 'input[name=?]', 'company_asset[type]'

      assert_select 'input[name=?]', 'company_asset[name]'

      assert_select 'input[name=?]', 'company_asset[user_id]'
    end
  end
end
