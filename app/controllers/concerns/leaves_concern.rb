# frozen_string_literal: true

module LeavesConcern
  extend ActiveSupport::Concern
  included do
    before_action :get_status, only: %i[new]
    before_action :set_leave, only: %i[show]
    before_action :check_approval_or_rejection, only: %i[index]
    before_action :authenticate_user!
    before_action :update_leaves_based_on_joining_date 
  end
  def create_leave
    previous_leaves = 0
    @user_applied_leaves = current_user.leaves.with_deleted.selected_leaves('approved')
    @user_applied_leaves.each do |previous_dates|
      if previous_dates.date_to == leave_params[:date_from] || previous_dates.date_to == leave_params[:date_to] || previous_dates.date_from == leave_params[:date_to] || previous_dates.date_from == leave_params[:date_from]
        previous_leaves = 1
      end
    end
    if previous_leaves == 1
      respond_to do |format|
        @leave.errors.add(:base, 'Sorry, you you have already applied for these days')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    elsif @leave.leave_type_normal
      render_create_format
    else
      respond_to do |format|
        @leave.is_type_short? ? @leave.errors.add(:base, "Sorry, you can only apply for #{@leave.apply_leave.allowed_hours} hours") : @leave.errors.add(:base, "Sorry, you can only apply for #{@leave.apply_leave.allowed_day} days")
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def render_create_format
    respond_to do |format|
      if @leave.save
        leave_notify_recipient(@leave, current_user, LeaveNotification)
        if current_user.user? && !current_user.is_hr
          users = User.where(user_type: %w[admin], company: @leave.company) + User.all_hrs + [@leave.user]
        elsif current_user.is_hr
          users = User.where(user_type: %w[admin], company: @leave.company)
        end
        if current_user.report_to.present? && current_user.report_to.allow_leave_approval == 'yes'
          users += [current_user.report_to]
        end
        users.uniq.each do |user|
          SendLeaveEmailJob.perform_now(@leave.id, current_user.id, user.id, nil)
        end
        format.html { redirect_to leaves_url, notice: 'Leave was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def approved_leaves
    @total_leaves = 0
    @user_leaves = current_user.leaves.selected_leaves('approved')
    count_total_leaves
  end

  def count_total_leaves
    @user_leaves = @user_leaves&.sum(:request_leaves)
  end

  def leave_notify_recipient(leave, employee, type)
    @leave = leave
    type.with(leave: @leave, user: current_user, admin_or_hr: nil).deliver(employee)
    get_notifications(employee)
    SendNotificationJob.perform_later(@unread.first, employee, @read.count)
    users = User.where(user_type: %w[admin], company: @leave.company) + User.all_hrs
    if current_user.report_to.present? && current_user.report_to.allow_leave_approval == 'yes'
      users += [current_user.report_to]
    end
    users.each do |user|
      if user == current_user
        unless employee.is_hr
          type.with(leave: @leave, user: employee, admin_or_hr: user, current_user: true).deliver(user)
        end
      else
        type.with(leave: @leave, user: employee, admin_or_hr: current_user,
                  current_user: false).deliver(user)
      end
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

  def set_leave
    @leave = Leave.find_by(id: params[:id])
    redirect_to root_path, notice: 'Leave does not exist' if @leave.nil?
  end

  def get_status
    if current_user.leaves.exists? && current_user.leaves.where(status: 'pending').exists?
      respond_to do |format|
        format.html { redirect_to leaves_url(status: 'pending'), alert: 'You already have pending leave request' }
      end
    else
      @leave = Leave.new
    end
  end

  def check_approval_or_rejection
    if params[:leave]
      @leave = Leave.find(params[:leave])
      @leave.update(status: params[:leave_status])
      leave_notify_recipient(@leave, @leave.user, LeaveApprovalNotification)
      users = User.where(user_type: %w[admin], company: @leave.company) + User.all_hrs + [@leave.user]
      if current_user.report_to.present? && current_user.report_to.allow_leave_approval == 'yes' && current_user.company == @leave.company
        users += [current_user.report_to]
      end
      users.uniq.each do |user|
        SendLeaveEmailJob.perform_now(@leave.id, current_user.id, user.id, params[:leave_status])
      end
    end
  end

  def render_format
    authorize Leave
    if params[:leave_status]
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def hours_date
    @leave_type = ApplyLeave.find_by_id(params[:id])
  end

  def update_leaves_based_on_joining_date
    active_users = User.all
    active_users&.each do |user|
      user.leaves.includes(:apply_leave, :files_attachments).where("EXTRACT(year FROM created_at) < ?", Date.today.year)&.each do |leave|
        leave.update(request_leaves: 0, hours: 0)
      end
    end
  end
end
