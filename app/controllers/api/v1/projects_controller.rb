# app/controllers/api/v1/projects_controller.rb
# frozen_string_literal: true

module Api
  module V1
    # API version for projects controller
    class ProjectsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_request

      # List of all Projects
      def index
        projects = current_user.projects
        if projects.present?
          render json: projects, status: 200
        else
          render json: { message: 'No Project Avaiable' }
        end
      end
    end
  end
end
