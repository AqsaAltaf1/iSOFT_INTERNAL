# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[create new show]
  before_action :set_user, only: %i[edit show profile_url destroy]
  before_action :check_user, only: [:update]
  before_action :set_city_state, only: [:new, :create, :edit, :update]
  before_action :authorize_user, only: %i[edit show profile_url destroy]
  def show
    mark_user_notifications_as_read
  end

  def new
    @user = User.new
    @user.user_type = nil
    @address = @user.build_address
    @payment = @user.build_payment
    respond_to do |format|
      format.json { render json: { message: 'Success', cities: @cities, states: @states }, status: :ok }
      format.html
    end
  end

  def create
  @user = User.new(user_params) 
    respond_to do |format|
      if @user.save
        users = User.where(user_type: %w[admin])
        users.each do |user|
          UserNotification.with(created_user: @user, user: current_user).deliver(user)
          get_notifications(user)
          SendNotificationJob.perform_later(@unread.first, user, @read.count)
        end
        format.html { redirect_to home_employee_details_path, notice: 'User is successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('user_form',
                                                    partial: 'users/form',
                                                    locals: { user: @user })
        end
      end
    end
  end

  def edit
    @address = @user.address
    @payment = @user.payment
  end

  def update_user; end

  def update
    if @user.update(user_params.merge!(status: 'active'))
      if current_user.present? && (current_user.is_hr || current_user.admin?)
        redirect_to home_employee_details_path, notice: 'Account has been updated successfully .'
      else
        sign_in(@user)
        redirect_to user_path(current_user), notice: 'Account has been updated successfully .'
      end
    else
      redirect(params[:user])
    end
  end

  def destroy
    destroy_user_with_notifications(@user)
    @user.destroy
    respond_to do |format|
      format.html { redirect_to home_employee_details_path, notice: 'user is successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def profile_url
    render json: { profile_url: user_path(@user) }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :joining_date, :status, :role_id, :employment_type, :first_name, :last_name, :location_id, :shift_id, :machine_code,
                                 :phone_number, :password, :avatar, :report_to_id, :user_type, :allow_leave_approval, :father_name, :user_designation_id,
                                  :mother_name, :blood_group, :qualification, :martial_status, :date_of_birth, :religion, :national_identity,
                                  :passport_number, :home_phone_no, :emergency_contact_name, :emergency_contact_phone_no, :probation_end_date, :hire_date,
                                  :gender, :eobi_number, :ntn_number, :salary_type, :base_salary, :starting_date, :department_id,
                                  address_attributes: [:id, :street, :city, :state, :zip, :country, :can_contact, :phone_number, :temporary_address, :permanent_address],
                                  payment_attributes: [:id, :payment_method, :bank_name, :branch_name, :branch_code, :account_number, :bank_code])

  end

  def check_user
    @user = User.find_by_email(params[:user][:email]) if params[:user][:email].present?
    return redirect_to request.referrer, alert: 'invalid email' unless @user
  end

  def redirect(user)
    respond_to do |format|
      if user[:sign_up_view].present?
        format.html { render 'devise/registrations/new', status: :unprocessable_entity }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('user_edit_form',
                                                    partial: 'users/form',
                                                    locals: { user: @user })
        end
      end
    end
  end

  def destroy_user_with_notifications(_user)
    if current_user.admin? && current_user.notifications.present?
      filtered_notifications = current_user.notifications.select do |notification|
        notification[:params] && notification[:params][:created_user] && notification[:params][:created_user][:id] == @user.id
      end
      filtered_notifications.each(&:destroy)
    end
  end
  def set_city_state
    @countries = CS.countries.map { |key, value| [value, key] }
    @selected_country = params[:country]
    @selected_state = params[:state]
    params[:country] ? @states = CS.states(params[:country]).map { |key, value| [value, key] } : @states = CS.states('US').map { |key, value| [value, key] }
    params[:state] ? @cities = CS.cities(params[:state],params[:country]).each { |value| [value] } : @cities = CS.cities(:AK, :US).each { |value| [value] }
  end

  def authorize_user
    authorize @user
  end
end
