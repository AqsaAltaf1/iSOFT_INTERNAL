# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'supports/show', type: :view do
  before(:each) do
    @support = assign(:support, Support.create!(
                                  subject: 'Subject',
                                  email: 'Email',
                                  description: 'MyText',
                                  user: nil
                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
