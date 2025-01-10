# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'help_documents/new', type: :view do
  before(:each) do
    assign(:help_document, HelpDocument.new(
                             name: 'MyString'
                           ))
  end

  it 'renders new help_document form' do
    render

    assert_select 'form[action=?][method=?]', help_documents_path, 'post' do
      assert_select 'input[name=?]', 'help_document[name]'
    end
  end
end
