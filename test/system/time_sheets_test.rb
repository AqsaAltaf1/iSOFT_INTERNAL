# frozen_string_literal: true

require 'application_system_test_case'

class TimeSheetsTest < ApplicationSystemTestCase
  setup do
    @time_sheet = time_sheets(:one)
  end

  test 'visiting the index' do
    visit time_sheets_url
    assert_selector 'h1', text: 'Time sheets'
  end

  test 'should create time sheet' do
    visit time_sheets_url
    click_on 'New time sheet'

    fill_in 'Description', with: @time_sheet.description
    fill_in 'Time', with: @time_sheet.time
    click_on 'Create Time sheet'

    assert_text 'Time sheet was successfully created'
    click_on 'Back'
  end

  test 'should update Time sheet' do
    visit time_sheet_url(@time_sheet)
    click_on 'Edit this time sheet', match: :first

    fill_in 'Description', with: @time_sheet.description
    fill_in 'Time', with: @time_sheet.time
    click_on 'Update Time sheet'

    assert_text 'Time sheet was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Time sheet' do
    visit time_sheet_url(@time_sheet)
    click_on 'Destroy this time sheet', match: :first

    assert_text 'Time sheet was successfully destroyed'
  end
end
