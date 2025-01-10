# app/controllers/evaluations_controller.rb
# frozen_string_literal: true

# Evaluations Controller for managing evaluations
class EvaluationsController < ApplicationController
  include Evaluation::CallBackModule
  include Evaluation::CrudModule
  before_action :set_evaluation, only: %i[show edit update destroy]
  before_action :check_user_feedback, only: [:employee_evaluation]
  before_action :prevent_approved_active, only: [:edit]
  after_action  :assigned_user, only: %i[create update]
  before_action :authenticate_user!
  # GET /evaluations or /evaluations.json
  def index
    index_evaluations
    authorize @evaluations
  end

  def completed_evaluation
    @evaluation = Evaluation.find(params[:evaluation_notification])
    @user = AssignedUser.find(params[:assigned_user]).user
    @feedback = EvaluationFeedBack.for_assigned_user_and_questions(params[:assigned_user],
                                                                   @evaluation.questions.pluck(:id))
    authorize @evaluation
    mark_evaluation_notifications_as_read if params[:evaluation_notification].present?
  end

  def user_evaluation
    @evaluations = current_user.evaluations.user_evaluations(current_user)
    mark_evaluation_notifications_as_read if params[:evaluation_notification].present?
    authorize @evaluations
  end

  def employee_evaluation
    mark_evaluation_notifications_as_read if params[:evaluation_notification].present?
  end

  def show
    @evaluation = Evaluation.find(params[:id])
    @evaluation_notes = @evaluation.notes
    authorize @evaluation
    mark_evaluation_notifications_as_read
  end

  # GET /evaluations/new
  def new
    @evaluation = Evaluation.new
    @question = @evaluation.questions.build
    authorize @evaluation
  end

  def approve_evaluation_status
    approve_evaluations
  end

  def active_evaluation_status
    active_evaluations
  end

  def reject_evaluation_status
    rejected_evaluation
  end

  # GET /evaluations/1/edit
  def edit
    authorize @evaluation
  end

  # POST /evaluations or /evaluations.json
  def create
    create_evaluation
  end

  def create_feedback
    evaluation_feed_back
  end

  # PATCH/PUT /evaluations/1 or /evaluations/1.json
  def update
    update_evaluation
  end

  # DELETE /evaluations/1 or /evaluations/1.json
  def destroy
    destroy_evaluation
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def evaluation_params
    params.require(:evaluation).permit(:evaluation_type, :created_by, :status, :feedback, :title,
                                       questions_attributes: [:id, :question, :question_type, :_destroy, { evaluation_options_attributes: %i[id option _destroy] }])
  end
end
