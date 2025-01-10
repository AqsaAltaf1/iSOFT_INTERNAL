# frozen_string_literal: true

require 'test_helper'

class TimeSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_sheet = time_sheets(:one)
  end

  test 'should get index' do
    get time_sheets_url
    assert_response :success
  end

  test 'should get new' do
    get new_time_sheet_url
    assert_response :success
  end

  test 'should create time_sheet' do
    assert_difference('TimeSheet.count') do
      post time_sheets_url, params: { time_sheet: { description: @time_sheet.description, time: @time_sheet.time } }
    end

    assert_redirected_to time_sheet_url(TimeSheet.last)
  end

  test 'should show time_sheet' do
    get time_sheet_url(@time_sheet)
    assert_response :success
  end

  test 'should get edit' do
    get edit_time_sheet_url(@time_sheet)
    assert_response :success
  end

  test 'should update time_sheet' do
    patch time_sheet_url(@time_sheet),
          params: { time_sheet: { description: @time_sheet.description, time: @time_sheet.time } }
    assert_redirected_to time_sheet_url(@time_sheet)
  end

  test 'should destroy time_sheet' do
    assert_difference('TimeSheet.count', -1) do
      delete time_sheet_url(@time_sheet)
    end

    assert_redirected_to time_sheets_url
  end
end
