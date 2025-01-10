# app/controllers/api/v1/admin/leaves_controller.rb
# frozen_string_literal: true

module Api
  module V1
    module Admin
      # API version for Leaves Controller at admin management side
      class LeavesController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authenticate_api_request

        # List of All Leaves
        def index
          leaves = Leave.all
          if leaves&.present?
            render json: leaves, status: 200
          else
            render json: { message: 'No leaves found' }
          end
        end

        # Approve/Reject Leaves
        def update
          leave = Leave.find(params[:id])
          status = params[:get_status].downcase if params[:get_status].present?
          if status && leave.update(status:)
            render json: { message: "Leave Successfully updated to status: #{status}" }
          else
            render json: { error: 'Not Updated-Try Again' }
          end
        end
      end
    end
  end
end
