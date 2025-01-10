# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'company_assets/index', type: :view do
  before(:each) do
    assign(:company_assets, [
             CompanyAsset.create!(
               model: 'Model',
               type: 'Type',
               name: 'Name',
               user: nil
             ),
             CompanyAsset.create!(
               model: 'Model',
               type: 'Type',
               name: 'Name',
               user: nil
             )
           ])
  end

  it 'renders a list of company_assets' do
    render
    assert_select 'tr>td', text: 'Model'.to_s, count: 2
    assert_select 'tr>td', text: 'Type'.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
