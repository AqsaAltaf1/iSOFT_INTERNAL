# app/controllers/users/registrations_controller.rb
# frozen_string_literal: true

module Users
  # users registration controller
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      @user = User.find_by(email: params[:email])
    end

    # POST /resource
    def create
      ################ Maybe use in future
      # @user = Admin.where(user_email: params[:user][:email]).first
      # if @user
      #   params[:user][:joining_date] = @user.joining_date
      #   super
      # else
      #   flash[:alert] = 'Only Isoft Studios authorized employee(s) are allowed to sign up here'
      #   redirect_to new_user_registration_path
      # end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource

    # DELETE /resource

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[
                                          email
                                          first_name
                                          last_name
                                          password
                                          password_confirmation
                                          joining_date
                                          phone_number
                                        ])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:email,
                                                                :first_name,
                                                                :last_name,
                                                                :password,
                                                                :password_confirmation,
                                                                :current_password,
                                                                :phone_number,
                                                                { address: %i[street city state zip country] }])
    end

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      # super(resource)
      after_signup_path('set_address')
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    private

    def address_params
      params.require(:address).permit(:street, :city, :state, :zip, :country, :can_contact, :phone_number)
    end
  end
end
