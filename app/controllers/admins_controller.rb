# app/controllers/admins_controller.rb

# frozen_string_literal: true

# admin controller to perform CRUD operations, see admin dashboard
class AdminsController < ApplicationController
  require 'csv'

  before_action :get_user, only: %i[sheet data view_attachments]
  before_action :set_admin, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :users, only: %i[leave_section requests_section]
  def index
    if current_user.admin? || current_user.is_hr
      @user_timesheets = User.joins(:time_sheets).where('time_sheets.status': 'pending').uniq
      mark_time_sheet_notifications_as_read
    else
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
  end

  def leave_section
    @leave_sections

    # if current_user.admin? || current_user.is_hr()

    # else
    #   redirect_to root_path, notice: "you are not allowed to access this page because you are not authorized"
    # end
  end

  def requests_section
    @requests_sections
  end

  def all_employee_attendance
    @users = User.all
    params[:date].present? ?
      @options = { start_date:  Date.parse(params[:date]).beginning_of_month, end_date:  Date.parse(params[:date]).end_of_month }
    : @options = { start_date: Date.today.beginning_of_month, end_date: Date.today.end_of_month }
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream:
          turbo_stream.replace('all_employee_attendance',
                                partial: 'all_attendances',
                                locals: { options: @options, users: @users})
      end
      format.html 
      format.csv do
        filename = "Users_#{Date.today}.csv"
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=attendance"
        render template: 'admins/all_employee_attendance'
      end    
    end
  end

  def data
    if current_user.admin? || current_user.is_hr
      if params[:start_week].present?
        get_approve_week(params[:start_week], params[:end_week])
        hash_project(params[:date], params[:status])
      else
        params[:status] = params[:status].present? ? params[:status] : 'pending'
        hash_project(params[:date], params[:status])
        mark_time_sheet_notifications_as_read
      end
    else
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def view_attachments
    if current_user.user? && !current_user.is_hr
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    else
      @attachments = @user.attachments
    end
  end

  def attachments_users
    if current_user.user? && !current_user.is_hr
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    else
      @hrs = User.all_hrs.joins(:attachments).uniq
      @employees = User.employees_that_are_not_hrs.joins(:attachments).uniq
    end
  end

  def view_users
    if current_user.admin?
      @admins = Admin.all
    else
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
  end

  def new
    if current_user.admin?
      @admin = Admin.new
    else
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
  end

  def edit
    unless current_user.admin?
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
  end

  def show
    authorize @admin
  end

  def create
    @admin = Admin.new(admin_params)
    authorize @admin
    if @admin.save
      begin
        AdminMailer.notify_user(@admin).deliver_now
      rescue Net::SMTPUnknownError => e
        @admin.destroy
        respond_to do |format|
          format.html do
            redirect_to new_admin_path, status: 303,
                                        notice: 'This email is not present in our verified testing email please make sure you have a valid email address'
          end
        end
      else
        redirect_to admins_view_users_path, notice: 'Email is successfully created.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @admin
    if @admin.update(admin_params)
      redirect_to admins_view_users_path, notice: 'Email is successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by_email(@admin.user_email)
    if user.present?
      Notification.where(params[:user] == user).destroy_all
      user&.destroy
    end
    @admin.destroy if @admin.present?
    redirect_to admins_view_users_path, notice: 'User is successfully deleted.', status: :see_other
  end

  def sheet
    if current_user.admin? || current_user.is_hr
      @weeks = []
      @time_sheets = @user.time_sheets.where(status: 'pending')
      @dates = []
      @time_sheets.each do |time_sheet|
        @dates.push(time_sheet.date)
      end
      @dates.uniq!
      @dates.sort!
      @dates.each do |date|
        if @weeks.present?
          @weeks.push(date) unless (@weeks.last.at_beginning_of_week..@weeks.last.at_end_of_week).cover?(date)
        else
          @weeks.push(date)
        end
      end

    else
      redirect_to root_path, notice: 'you are not allowed to access this page because you are not authorized'
    end
  end

  private

  def generate_csv(users)
    CSV.generate(headers: true) do |csv|
      csv << ["User ID", "User Name", "check_in", "check_out"]

      users.each do |user|
        @full_name = user.first_name + " " + user.last_name
        user.attendances.each do |attendance|
          @check_in = attendance.check_in.present? ? DateTime.parse((attendance.check_in).to_s).strftime("%b %d %I:%M:%S %p %Y") : nil
          @check_out = attendance.check_out.present? ? DateTime.parse((attendance.check_out).to_s).strftime("%b %d %I:%M:%S %p %Y") : nil
          csv << [user.machine_code, @full_name , @check_in, @check_out]
        end
      end
    end
  end

  def admin_params
    params.require(:admin).permit(:user_email, :joining_date)
  end

  def check_admin
    if current_user.admin?
      true
    else
      false
    end
  end

  def set_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  end

  def get_user
    @user = User.find(params[:user_id])
  end

  def set_hours(time_sheets)
    total_time_log = 0
    time_sheets.each do |time_sheet|
      hours, minutes, seconds = time_sheet.time.strftime('%H:%M:%S').split(':').map(&:to_i)
      total_time_log += (hours * 60 * 60) + (minutes * 60) + seconds
    end
    minutes, seconds = total_time_log.divmod(60)
    hours, minutes = minutes.divmod(60)
    "#{hours}:#{minutes}:#{seconds}"
  end

  def users
    @users = User.where.not(user_type: 'admin')
  end

  def get_approve_week(start_week, end_week)
    @time_sheets = @user.time_sheets.get_approve_week(start_week, end_week)
    @time_sheets.each do |time_sheet|
      time_sheet.update(status: params[:status_update])
    end
    notify_recipient(@time_sheets.last, @user, TimeSheetApprovelNotification)
  end
end
