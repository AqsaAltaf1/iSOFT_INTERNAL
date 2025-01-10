# app/controllers/questions_controller.rb

# frozen_string_literal: true

# questions controller to manage questions
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authenticate_user!
  after_action  :assign_to_user, only: %i[create update]
  def index
    @projects = Project.all
    authorize @projects
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        project_notify_recipient(@project)
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def show
    mark_project_notifications_as_read
  end

  def edit
    authorize @project
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        @project.notifications_as_project.destroy_all
        project_notify_recipient(@project)
        format.html { redirect_to projects_path, notice: 'Project updated successfully.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.notifications_as_project.destroy_all
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, user_ids: [])
  end

  def assign_to_user
    @project.user_projects.destroy_all if @project.created_at != @project.updated_at? && @project.user_projects
    params[:project][:user_ids]&.each do |user|
      UserProject.create(user_id: user, project_id: @project.id)
    end
  end

  def project_notify_recipient(project)
    project.users&.each do |user|
      ProjectNotification.with(project:, user: current_user).deliver(user)
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end
end
