# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'help_documents/edit', type: :view do
  before(:each) do
    @help_document = assign(:help_document, HelpDocument.create!(
                                              name: 'MyString'
                                            ))
  end

  it 'renders the edit help_document form' do
    render

    assert_select 'form[action=?][method=?]', help_document_path(@help_document), 'post' do
      assert_select 'input[name=?]', 'help_document[name]'
    end
  end
end
