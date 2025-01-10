# app/helpers/time_sheets_helper.rb
# frozen_string_literal: true

# time sheets helper module
module TimeSheetsHelper
  def select_time_sheet
    if params[:get_date]
      Date.parse("#{params[:get_date]}%").wday
    else
      Date.today.wday
    end
  end

  def select_selected_date
    Date.parse("#{params[:get_date]}%").strftime('%A, %d %b %Y')
  end

  def validate_dates(time_sheet)
    (Date.today.at_beginning_of_week..Date.today.at_end_of_week).cover?(time_sheet.date) && (time_sheet.status == 'draft' || time_sheet.status == 'archived')
  end

  def date_is_in_current_week(date)
    current_week.include?(date) && date <= Date.today
  end
end
