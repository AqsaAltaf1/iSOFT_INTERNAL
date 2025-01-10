# app/controllers/api/v1/hr/time_sheets_controller.rb
# frozen_string_literal: true

module Api
  module V1
    module Hr
      # API version for Time sheets controller at HR side
      class TimeSheetsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authenticate_api_request

        # Show all TimeSheet to Hr
        def index
          time_sheets = TimeSheet.all
          if time_sheets&.present?
            render json: time_sheets, status: 200
          else
            render json: { message: 'No TimeSheet Available' }
          end
        end

        # Update TimeSheet status (pending , approved , rejected)
        def update
          sheet = TimeSheet.find(params[:id])
          status = params[:get_status].downcase if params[:get_status].present?
          if status && sheet.update(status:)
            render json: { message: "TimeSheet Status updated to #{status}" }, status: 200
          else
            render json: { error: 'Not Updated-Try Again' }
          end
        end
      end
    end
  end
end
