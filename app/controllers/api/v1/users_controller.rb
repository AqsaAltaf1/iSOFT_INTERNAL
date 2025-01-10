# app/controllers/api/v1/users_controller.rb
# frozen_string_literal: true

module Api
  module V1
    # API version for admin controller
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_request

      # Edit Profile
      def update
        #  if current_user.update(user_params)
        #           render json: {message: "User updates" , user: current_user} , status:200
        #  else
        #           render json: {message: "#{current_user.errors.full_messages}"} , status:200
        #  end
        user = User.find(params[:id])
        if user.present?
          if user.update(user_params)
            render json: { message: 'User updates', user: }, status: 200
          else
            render json: { message: user.errors.full_messages.to_s }
          end
        else
          render json: { message: user.errors.full_messages.to_s }
        end
      end

      # View Profile
      def show
        user = User.find(current_user.id)
        render json: { user: }
      end

      private

      def user_params
        params.permit(:email, :first_name, :last_name, :user_type, :address_id, :phone_number, :password,
                      :can_contact)
      end
    end
  end
end
