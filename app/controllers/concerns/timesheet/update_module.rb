# frozen_string_literal: true

module Timesheet
  module UpdateModule
    include ActiveSupport::Concern

    def update_conditions
      if TimeSheet.validate_update_time_sheet_time(@time_sheet, time_sheet_params, current_user, params)
        redirect_to time_sheets_path(data: @time_sheet.date.strftime('%A'), n_time_sheet: @time_sheet),
                    alert: 'Sorry You Can Create Time Sheets For 12 hours in a Day.'
      else
        @time_sheet.update(time_sheet_params)
        if @time_sheet.update(time_sheet_params)
          update_conditions_else_if_part
        else
          update_conditions_else_else_part
        end
      end
    end

    def update_conditions_else_if_part
      respond_to do |format|
        format.html do
          redirect_to time_sheets_path(data: @time_sheet.date.strftime('%A'), n_time_sheet: @time_sheet),
                      notice: 'Time sheet updated successfully.'
        end
        format.json { render :show, status: :ok, location: @time_sheet }
      end
    end

    def update_conditions_else_else_part
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end
end
