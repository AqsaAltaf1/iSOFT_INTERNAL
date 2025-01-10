# app/controllers/api/v1/employee/time_sheets_controller.rb
# frozen_string_literal: true

module Api
  module V1
    module Employee
      # API version for Time sheets controller at employee side
      class TimeSheetsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authenticate_api_request
        # Get Timesheet with specific date
        # def index
        #     params[:get_date] = TimeSheet.get_selected_date(params[:data], params[:get_date].to_s)
        #     time_sheets = policy_scope(TimeSheet.current_date(params[:get_date], params[:status].present? ? params[:status].downcase : "draft"))
        #     # mark_time_sheet_notifications_as_read
        #     # render_format(params[:get_date])
        #     if time_sheets.present?
        #     render json: @time_sheets , status:200
        #     else
        #         render json: {error: "No TimeSheet Created"}
        #     end
        # end
        #  Get Timesheet with status {Archived , Draft , Pending , Deleted , Approved}
        def timesheet_status
          @time_sheets = TimeSheet.where(status: params[:get_status], date: params[:get_date])
          if @time_sheets.present?
            # Change Time zone to "EST" and make an array then add all values. because in we can only render json in one time
            objArray = []
            @time_sheets.each do |t|
              project = Project.find(t.project_id).name
              @arr = objArray.push(id: t.id, time: t.time, project_name: project, description: t.description)
            end
            render json: { sheet: @arr }
          else
            render json: { error: 'Timesheet not available' }
          end
          puts 'TimeSheet Present outside'
        end

        # Weekly approval for timesheets
        def approval_request
          if params[:approval_request]&.present?
            @time_sheets = TimeSheet.current_week_time_sheets(current_user.id)
            if @time_sheets.present?
              @time_sheets.each do |time_sheet|
                time_sheet.update(status: 'pending')
              end
              # notify_recipient(@time_sheets.last, current_user, TimeSheetNotification)
              render json: { message: 'Approval Submitted' }
            else
              render json: { error: "[#{current_user.email}] has no Timesheets for submission" }
            end
          else
            render json: { error: 'Request Error-Try Again' }
          end
        end

        # Create TimeSheet for employee
        def create
          timesheet = TimeSheet.new(timesheet_params)
          timesheet.user_id = current_user.id
          if timesheet.date >= Date.today.at_beginning_of_week && timesheet.date <= Date.today.at_end_of_week

            if timesheet.save
              render json: { message: 'Time Sheet Created Successfully' }, status: 200
            else
              render json: { error: 'Time Sheet Creation Error-Try Again' }
            end
          else
            render json: { error: 'You can only create timesheet in this week' }
          end
        end

        private

        def timesheet_params
          params.permit(:description, :project_id, :time, :date)
        end
      end
    end
  end
end
