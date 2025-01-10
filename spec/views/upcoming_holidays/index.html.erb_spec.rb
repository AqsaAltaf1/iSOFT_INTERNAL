# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'upcoming_holidays/index', type: :view do
  before(:each) do
    assign(:upcoming_holidays, [
             UpcomingHoliday.create!(
               title: 'Title',
               description: 'MyText'
             ),
             UpcomingHoliday.create!(
               title: 'Title',
               description: 'MyText'
             )
           ])
  end

  it 'renders a list of upcoming_holidays' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
