# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'help_documents/show', type: :view do
  before(:each) do
    @help_document = assign(:help_document, HelpDocument.create!(
                                              name: 'Name'
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
