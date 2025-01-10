# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'upcoming_holidays/edit', type: :view do
  before(:each) do
    @upcoming_holiday = assign(:upcoming_holiday, UpcomingHoliday.create!(
                                                    title: 'MyString',
                                                    description: 'MyText'
                                                  ))
  end

  it 'renders the edit upcoming_holiday form' do
    render

    assert_select 'form[action=?][method=?]', upcoming_holiday_path(@upcoming_holiday), 'post' do
      assert_select 'input[name=?]', 'upcoming_holiday[title]'

      assert_select 'textarea[name=?]', 'upcoming_holiday[description]'
    end
  end
end
