# app/controllers/questions_controller.rb

# frozen_string_literal: true

# questions controller to manage questions
class QuestionsController < ApplicationController
  before_action :set_evaluation, only: %i[show edit update destroy]
  before_action :check_approval_or_rejection, only: %i[index]
  before_action :new_evaluation, only: %i[index new active_status]
  def index
    @questions = Question.where(status: params[:status].present? ? params[:status].downcase : 'pending')
    render_format
  end

  # def user_evaluation
  #   @questions =  Question.includes(:evaluation_feed_backs).where(status: "active")
  # end

  def show
    authorize @question
    mark_evaluation_notifications_as_read
  end

  def new
    @question.evaluation_options.build
    authorize @question
  end

  def approve_evaluation_status
    @approval = params[:approval_evaluation_array]
    @approval&.each do |approve_status|
      @status_evaluation = Question.find(approve_status)
      @status_evaluation.status = 'approved'
      @status_evaluation.save
    end
    render_format
  end

  def active_status
    @active = params[:active_question_array]
    @active&.each do |active_status|
      @status_evaluation = Question.find(active_status)
      @status_evaluation.status = 'active'
      @status_evaluation.save
    end
    render_format
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    @admin = User.where(user_type: 'admin')
    respond_to do |format|
      if @question.save
        evaluation_notify_recipient(@question, @question.user, EvaluationNotification)
        @admin.each do |ad|
          EvaluationMailer.question_create(ad.email).deliver_now
        end
        format.html { redirect_to evaluations_path, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        @questions = Question.where(status: params[:status].present? ? params[:status].downcase : 'pending')
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_feedback
    params[:filteredArray]&.each do |t|
      evaluation_id = t[1].keys[0]
      option_id = t[1].values[0]
      EvaluationFeedBack.create(question_id: evaluation_id, evaluation_options_id: option_id,
                                user_id: current_user.id)
    end
    respond_to do |format|
      format.js { render user_evaluation_questions_path, notice: 'you have done it!!!!!!!!!!' }
    end
  end

  def update
    authorize @question
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question), notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_evaluation
    @question = Question.find(params[:id])
  end

  def check_approval_or_rejection
    if params[:question]
      @question = Question.find(params[:question])
      @question.update(status: params[:evaluation_status])
      evaluation_notify_recipient(@question, @question.user, EvaluationApprovalNotification)
      # leave_notify_recipient(@leave, @leave.user, LeaveApprovalNotification)
      # LeaveMailer.leaves_mailer(@leave, current_user, params[:leave_status]).deliver_now
    end
  end

  def new_evaluation
    @question = Question.new
  end

  def render_format
    if params[:evaluation_status] || params[:status] || params[:arr]
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  # Only allow a list of trusted parameters through.

  def question_params
    params.require(:question).permit(:question, :question_type,
                                     evaluation_options_attributes: %i[id question_id option _destroy])
  end
end
