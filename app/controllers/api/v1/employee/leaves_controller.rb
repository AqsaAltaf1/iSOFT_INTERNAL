# app/controllers/api/v1/employee/leaves_controller.rb
# frozen_string_literal: true

module Api
  module V1
    module Employee
      # API version for leaves controller at employee side
      class LeavesController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authenticate_api_request

        # Create new Leave
        def create
          approved_leaves
          if current_user.leaves.exists? && current_user.leaves.where(status: 'pending').exists?
            render json: { message: 'You Already Have pending Leave Request' }
          else
            @allowed_leaves = Leave::ALLOWED_LEAVES
            @leave = Leave.new(leave_params)
            @leave.user_id = current_user.id
            if @leave.leave_type == 'normal'
              if helpers.leave_type_normal(@total_leaves)

                if @leave.save
                  LeaveMailer.leaves_mailer(@leave, current_user, nil).deliver_now
                  render json: { message: 'Leave was successfully created.' }
                else
                  render json: { error: 'Leave Creation Error-Try Again' }
                end
              else
                render json: { error: "Sorry, you can only applied for #{Leave::ALLOWED_LEAVES - @total_leaves} days" }
              end
            elsif @leave.date_from.present? || @leave.date_to.present?
              render json: { error: 'Wrong num of argments' }
            elsif @leave.save
              LeaveMailer.leaves_mailer(@leave, current_user, nil).deliver_now
              render json: { message: 'Leave was successfully created.' }
            else
              render json: { error: 'Leave Creation Error-Try Again' }
            end
          end
        end

        # Get Leaves(Pending,Approved,Rejected)
        def index
          if params[:get_status]&.present?
            status = params[:get_status].downcase
            @leaves = Leave.where(status:)
            if @leaves&.present?
              render json: @leaves, status: 200
            else
              render json: { error: "You have no data regarding #{status} leave" }
            end
          else
            render json: { error: 'Error-Try Again' }, status: 404
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

        private

        def leave_params
          params.permit(:leave_type, :date_from, :date_to, :hours, :body)
        end
      end
    end
  end
end
