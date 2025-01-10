# app/controllers/api/v1/passwords_controller.rb
# frozen_string_literal: true

module Api
  module V1
    # API version for passwords controller, managing passwords of the users
    class PasswordsController < Devise::PasswordsController
      skip_before_action :verify_authenticity_token

      # work as forgot password
      def create
        return render json: { error: 'Email not present' } if params[:email].blank?

        user = User.find_by(email: params[:email])
        if user.present?
          user.generate_password_token!
          render json: { status: 'ok' }, status: :ok
        else
          render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
        end
      end

      # work as reset password
      def update
        user = User.find_by(email: params[:api_v1_user][:email])
        if user.present? && user.password_token_valid?
          if params[:api_v1_user][:password].present? && params[:api_v1_user][:password_confirmation].present?
            if params[:api_v1_user][:password] == params[:api_v1_user][:password_confirmation]
              user.reset_password!(params[:api_v1_user][:password])
              render json: { alert: 'Your password has been successfuly reset!' }
            else
              render json: { alert: 'Confirmation Password not matched-try again' }
            end
          else
            render json: { error: 'Password Field Empty' }, status: :unprocessable_entity
          end
        else
          render json: { status: 'not ok' }
        end
      end
    end
  end
end
