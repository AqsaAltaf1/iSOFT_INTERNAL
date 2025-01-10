# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'help_documents/index', type: :view do
  before(:each) do
    assign(:help_documents, [
             HelpDocument.create!(
               name: 'Name'
             ),
             HelpDocument.create!(
               name: 'Name'
             )
           ])
  end

  it 'renders a list of help_documents' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
  end
end
