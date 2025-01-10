# app/controllers/leaves_controller.rb
# frozen_string_literal: true

# leaves controller to manage leaves

# frozen_string_literal: true

class LeavesController < ApplicationController
  protect_from_forgery except: :index
  before_action :authenticate_user!
  include LeavesConcern
  before_action :approved_leaves, only: %i[new create index]
  before_action :get_status, only: %i[new]
  before_action :set_leave, only: %i[show]
  before_action :check_approval_or_rejection, only: %i[index]
  before_action :set_short_leave_type, only: %i[new create edit update]
  before_action :find_leave, only: %i[edit update destroy]
  before_action :set_authorization, only: %i[new create destroy]

  def index
    status = params[:leave_status].present? ? params[:leave_status].downcase : 'pending'
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @leaves = @user.leaves.selected_leaves('approved')
    else
      @leaves = current_user.leaves.selected_leaves(status)
    end
    @types_leaves = @leaves.group(:apply_leave_id).count
    mark_leave_notifications_as_read
    render_format
    # redirect_to leaves_path
  end

  def new
    @leave = Leave.new
  end

  def create
    @leave = current_user.leaves.build(leave_params)
    create_leave
  end

  def show
    if current_user.admin? || current_user.is_hr || current_user.report_to.present?
      @leave = Leave.find(params[:id])
      mark_leave_notifications_as_read
    elsif current_user == @leave.user
      @leave = Leave.find(params[:id])
    else
      respond_to do |format|
        format.html { redirect_to leaves_url, alert: 'You are not authorize for this.' }
      end
    end
    @leave_notes = @leave.notes.order(created_at: :asc)
    mark_leave_notifications_as_read
  end

  def edit; end

  def update
    respond_to do |format|
      if @leave.update(leave_params)
        format.html { redirect_to leave_path(@leave), notice: 'Leave was successfully updated.' }
        format.json { render :show, status: :ok, location: @leave }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @leave.notifications_as_leave.destroy_all
    @leave.destroy
    respond_to do |format|
      format.html { redirect_to admins_leave_section_path, notice: 'Leave is successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_authorization
    authorize Leave
  end

  def find_leave
    @leave = Leave.find(params[:id])
  end

  def leave_params
    params.require(:leave).permit(:from_time, :to_time, :date_from, :date_to, :hours, :short_type, :body, :apply_leave_id, files: [])
  end

  def set_short_leave_type
    @short_type = Leave.short_types.keys
    @apply_leaves = ApplyLeave.all
  end
end
