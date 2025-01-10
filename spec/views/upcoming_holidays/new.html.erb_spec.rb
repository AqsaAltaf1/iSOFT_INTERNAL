# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'upcoming_holidays/new', type: :view do
  before(:each) do
    assign(:upcoming_holiday, UpcomingHoliday.new(
                                title: 'MyString',
                                description: 'MyText'
                              ))
  end

  it 'renders new upcoming_holiday form' do
    render

    assert_select 'form[action=?][method=?]', upcoming_holidays_path, 'post' do
      assert_select 'input[name=?]', 'upcoming_holiday[title]'

      assert_select 'textarea[name=?]', 'upcoming_holiday[description]'
    end
  end
end
