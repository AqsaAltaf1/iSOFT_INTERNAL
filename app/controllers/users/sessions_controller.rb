# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # prepend_before_action :set_tenant
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      user = User.find_by(email: params[:user][:email].downcase)
      if user && warden.authenticate!(auth_options)
        if params[:user][:remember_me] == '1'
          cookies[:remembered_email] = { value: params[:user][:email], expires: 30.days.from_now }
        else
          cookies.delete(:remembered_email)
        end
        sign_in(user)
        redirect_to root_path
      else
        flash[:alert] = "Invalid email or password"
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity, locals: { resource: User.new } }# Render the login form again with an error message
        end
      end
    end
    # In your SessionsController
    # On main domain
    # def create
    #   user = User.find_by_email(params[:user][:email])

    #   if user && user.valid_password?(params[:user][:password]) && user.company.present?
    #     # Generate a one-time JWT token
    #     payload = { user_id: user.id, exp: 1.hour.from_now.to_i }
    #     token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')

    #     # Redirect to the subdomain with the token
    #     redirect_to authenticate_from_token_url(subdomain: request.subdomain, token: token, host: request.host), allow_other_host: true

    #     # Destroy session cookie
    #     request.session_options[:skip] = true
    #   elsif
    #     super
    #   else
    #     flash[:alert] = "Invalid email or password"
    #     render :new
    #   end
    # end

    # # On subdomain
    # def authenticate_from_token
    #   # Extract and verify the JWT token
    #   decoded_token = JWT.decode(params[:token], Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
    #   user_id = decoded_token[0]['user_id']

    #   # Authenticate the user
    #   user = User.find(user_id)
    #   sign_in(:user, user)

    #   redirect_to root_path
    # end

    # In another controller or action on the subdomain

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
