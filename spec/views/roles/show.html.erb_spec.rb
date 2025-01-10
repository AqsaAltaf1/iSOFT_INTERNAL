# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'roles/show', type: :view do
  before(:each) do
    @role = assign(:role, Role.create!(
                                          name: 'Name',
                                          company: nil
                                        ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
