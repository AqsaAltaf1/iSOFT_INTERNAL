# app/controllers/application_controller.rb
# frozen_string_literal: true

# application controller for the rails app
class ApplicationController < ActionController::Base
  helper CompaniesHelper
  # before_action :set_mailer_host
  # before_action :store_current_request
  set_current_tenant_through_filter
  before_action :set_tenant
  # set_current_tenant_by_subdomain(:company, :subdomain)
  before_action :set_notifications, if: :current_user
  before_action :authenticate_user!
  # before_action :verify_session, if: :current_user

  include AdminPanel
  include NotificationsAsRead
  include Notify
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters,
                if: :devise_controller?

  def authenticate_api_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      # @decoded = JsonWebToken.decode(header)
      key = Rails.application.secrets.secret_key_base.to_s
      decoded = JWT.decode(header, key)[0]
      HashWithIndifferentAccess.new decoded
      @current_user = User.find(decoded.values[0])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
    # @current_user = AuthorizeApiRequest.call(request.headers).result
    # render json: { error: 'Not Authorized' }, status: 401  #unless @current_user
  end

  def mark_all_notifications_as_read
    current_user.notifications.mark_as_read!
    set_notifications
  end

  def see_all_notifications; end

  protected

  def set_tenant
    company = find_company
    set_current_tenant(company) if company
  end

  def store_current_request
    Thread.current[:current_request] = request
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options = { host: request.host, port: request.port }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end

  private

  def find_company
    return current_user&.company if current_user
    return User.includes(:company).find_by_email(params[:email])&.company if params[:email].present?
  end

  def verify_session
    if current_user.company.present?
      return if request.subdomain == current_user&.company&.subdomain

      reset_session
    end
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (if current_user.user_type == 'user' && !current_user.is_hr
                                        home_employee_path
                                      end) || (if current_user.user_type == 'admin' || current_user.super_admin?
                                                 root_path
                                               end) || (home_hr_path if current_user.is_hr)
  end

  def set_notifications
    notifications = Notification.includes([:recipient]).where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
