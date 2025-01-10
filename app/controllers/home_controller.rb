# app/controllers/home_controller.rb
# frozen_string_literal: true

# frozen_string_literal: true

# controller for showing home page of the registered users
class HomeController < ApplicationController
  include HomeConcern

  def home
    if current_user.present?
      if current_user.user?
        redirect_to home_employee_path unless current_user.is_hr
        redirect_to home_hr_path if current_user.is_hr
      else
        redirect_to home_admin_path
      end
    end
  end

  def employee
    redirect_to root_path unless current_user&.user?
  end

  def hr
    redirect_to root_path unless current_user&.is_hr()
  end

  def employee_details
    @employees = User.includes([:role]).includes([:report_to]).order(id: :desc)
    update_status_of_user
  end

  def contact_list
    @contact_list_users = User.contact_list_present
  end

  def search
    @search_users = User.searched_users(params[:q])
    @search_evaluations = Evaluation.searched_evaluations(params[:q])
    @search_projects = Project.searched_projects(params[:q])
    respond_to do |format|
      format.html
    end
  end
end
