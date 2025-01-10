# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'upcoming_holidays/show', type: :view do
  before(:each) do
    @upcoming_holiday = assign(:upcoming_holiday, UpcomingHoliday.create!(
                                                    title: 'Title',
                                                    description: 'MyText'
                                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
