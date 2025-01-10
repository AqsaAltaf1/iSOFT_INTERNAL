# app/controllers/api/v1/users/sessions_controller.rb
# frozen_string_literal: true

module Api
  module V1
    module Users
      # API version for user session controller
      class SessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token

        def create
          command = AuthenticateUser.call(params[:email], params[:password])
          if command.success?
            user = User.find_by(email: params[:email])
            if user.valid_password?(params[:password])
              render json: { message: 'User successfully logged in', is_login: true, data: { user:, auth_token: command.result } },
                     status: 200
            else
              render json: { error: 'Signed in failed - unauthorized', is_login: false }
            end
          else
            render json: { error: 'Signed in failed - unauthorized' }
          end
        end
      end
    end
  end
end
