# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'company_assets/show', type: :view do
  before(:each) do
    @company_asset = assign(:company_asset, CompanyAsset.create!(
                                              model: 'Model',
                                              type: 'Type',
                                              name: 'Name',
                                              user: nil
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Model/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
