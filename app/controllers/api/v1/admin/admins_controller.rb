# app/controllers/api/v1/admin/admins_controller.rb

# frozen_string_literal: true

module Api
  module V1
    module Admin
      # API version for admin controller
      class AdminsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authenticate_api_request

        # List of all new Users
        def index
          users = Admin.all
          render json: users, status: 200
        end

        #  Add New User
        def create
          admin = Admin.new(admin_params)
          user = Admin.find_by(user_email: admin.user_email)
          if !user.present?
            if admin.save
              render json: { message: 'User Successfully Added' }, status: 200
            else
              render json: { error: 'User Not Added-Try Again' }
            end
          else
            render json: { message: 'Email Already Exists-Please Try another email' }
          end
        end

        # Edit New User
        def update
          user = Admin.find(params[:id])
          if user.present?
            if params[:user_email].present? || params[:joining_date].present?
              # if params[:user_email].present?
              check = Admin.find_by(user_email: params[:user_email])
              if check.present?
                render json: { error: 'This Email Already exists, Kinldy Choose another email' }
              else
                user.update(admin_params)
                render json: { message: 'User Updated Successfully' }
              end
            # end
            else
              render json: { message: 'User Not Updated-Try Again' }
            end
          end
        end

        private

        def admin_params
          params.permit(:user_email, :joining_date)
        end
      end
    end
  end
end
