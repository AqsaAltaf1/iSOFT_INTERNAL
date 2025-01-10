# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'supports/index', type: :view do
  before(:each) do
    assign(:supports, [
             Support.create!(
               subject: 'Subject',
               email: 'Email',
               description: 'MyText',
               user: nil
             ),
             Support.create!(
               subject: 'Subject',
               email: 'Email',
               description: 'MyText',
               user: nil
             )
           ])
  end

  it 'renders a list of supports' do
    render
    assert_select 'tr>td', text: 'Subject'.to_s, count: 2
    assert_select 'tr>td', text: 'Email'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
