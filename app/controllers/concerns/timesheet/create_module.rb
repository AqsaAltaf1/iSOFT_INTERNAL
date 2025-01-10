# frozen_string_literal: true

module Timesheet
  module CreateModule
    include ActiveSupport::Concern

    def create_timesheet_else_part
      if @time_sheet.save
        create_timesheet_else_part_if
      else
        create_timesheet_else_part_else
      end
    end

    def create_timesheet_else_part_if
      respond_to do |format|
        format.html do
          redirect_to time_sheets_path(data: @time_sheet.date.strftime('%A'), id: @time_sheet),
                      notice: 'Time sheet created successfully.'
        end
        format.json { render :show, status: :created, location: @time_sheet }
      end
    end

    def create_timesheet_else_part_else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end
end
