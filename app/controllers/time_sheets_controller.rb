# app/controllers/time_sheets_controller.rb
# frozen_string_literal: true

# time sheets controller to manage time sheets for users
class TimeSheetsController < ApplicationController
  include Timesheet::CallBackModule
  include Timesheet::CreateModule
  include Timesheet::UpdateModule
  include TimeSheetsHelper
  before_action :set_time_sheet, only: %i[show edit update destroy]
  before_action :validate_date, only: %i[edit]
  before_action :approval_request, :get_add_remove_archived, :check_admin, only: %i[index]
  before_action :authenticate_user!

  # GET /time_sheets or /time_sheets.json
  def index
    get_timesheets
  end

  def calander_view
    respond_to do |format|
      if request.format.html?
        format.html
      else
        format.js
      end
    end
  end

  # GET /time_sheets/1 or /time_sheets/1.json
  def show
    authorize @time_sheet
  end

  # GET /time_sheets/new
  def new
    @projects = current_user.projects
    @time_sheet = TimeSheet.new
    @time_sheet.date = Date.today
    authorize @time_sheet
  end

  # GET /time_sheets/1/edit
  def edit
    @projects = current_user.projects
  end

  def create
    @projects = current_user.projects
    @time_sheet = current_user.time_sheets.build(time_sheet_params)
    if TimeSheet.validate_timesheet_time(time_sheet_params, current_user)
      redirect_to time_sheets_path, alert: 'Sorry You Can Create Time Sheets For 12 hours in a Day.'
    else
      create_timesheet_else_part
    end
  end

  # PATCH/PUT /time_sheets/1 or /time_sheets/1.json
  def update
    @projects = current_user.projects
    authorize @time_sheet
    update_conditions
  end

  # DELETE /time_sheets/1 or /time_sheets/1.json
  def destroy
    @time_sheet.destroy
    respond_to do |format|
      format.html { redirect_to time_sheets_url, status: 303, notice: 'Time sheet deleted successfully' }
      format.json { head :no_content }
    end
  end

  def see_all_notification
    @notifications = current_user.notifications.newest_first
  end

  def mark_all_notification
    @notifications = current_user.notifications.newest_first
    current_user.notifications.mark_as_read!
    get_notifications(current_user)
    respond_to do |format|
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def time_sheet_params
    params.require(:time_sheet).permit(:time, :description, :project_id, :date)
  end
end
