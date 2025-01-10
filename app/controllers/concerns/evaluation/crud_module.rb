# frozen_string_literal: true

module Evaluation::CrudModule
  include ActiveSupport::Concern

  def index_evaluations
    @evaluations = Evaluation.where(status: params[:status].present? ? params[:status].downcase : 'pending')
    mark_evaluation_notifications_as_read if params[:evaluation_notification].present?
    mark_evaluation_destroy_notifications_as_read if params[:is_delete].present?
    @feedbacks = EvaluationFeedBack.select(:assigned_user_id).distinct
    render_format
  end

  def create_evaluation
    @evaluation = Evaluation.new(evaluation_params)
    @evaluation.created_by = current_user.id
    @user_hr = current_user
    user = User.where(user_type: 'admin')
    if @evaluation.save
      evaluation_notify_recipient(@evaluation, @evaluation.created_by, EvaluationNotification)
      user.each do |users|
        EvaluationMailer.evaluation_create(@user_hr, users.email, @evaluation.title).deliver_later
      end
      redirect_to_path('true', evaluations_url, 'Evaluation is successfully created.')
    else
      redirect_to_path('false')
    end
  end

  def update_evaluation
    if @evaluation.update(evaluation_params)
      evaluation_edit_notify_recipient(@evaluation, current_user, EvaluationEditNotification)
      redirect_to_path('true', evaluations_url, 'Evaluation is successfully updated.')
    else
      redirect_to_path('false')
    end
  end

  def destroy_evaluation
    @evaluation_title = @evaluation.title
    @evaluation.destroy
    evaluation_destroy_notify_recipient(@evaluation_title, current_user, EvaluationDestroyNotification)
    redirect_to_path('true', evaluations_url, 'Evaluation is successfully destroyed.')
  end

  def approve_evaluations
    @evaluations = Evaluation.status('pending')
    @approve_evaluations = Evaluation.where(id: params[:evaluations_status_update])
    @approved_evaluation = []
    users = User.all_hrs
    @approve_evaluations&.each do |approved_evaluation|
      approved_evaluation.update(status: 'approved')
      @approved_evaluation.push(approved_evaluation)
      evaluation_approve_notify_recipient(approved_evaluation, current_user, users, EvaluationApprovalNotification)
    end
    EvaluationMailer.evaluation_approved(users.pluck(:email), current_user, @approved_evaluation).deliver_later
    render_format
  end

  def active_evaluations
    @evaluations = Evaluation.status('approved')
    @active_evaluations = Evaluation.where(id: params[:evaluations_status_update])
    @active_evaluations&.each do |active_evaluation|
      active_evaluation.update(status: 'active')
      users = active_evaluation.users
      evaluation_active_notify_recipient(active_evaluation, current_user, users, EvaluationActiveNotification)
      EvaluationMailer.evaluation_active(users.pluck(:email), current_user, active_evaluation).deliver_later
    end
    render_format
  end

  def rejected_evaluation
    @evaluations = Evaluation.status('pending')
    @rejected_evaluations = Evaluation.where(id: params[:evaluations_status_update])
    @rejected_evaluation = []
    @rejected_evaluations&.each do |rejected_evaluation|
      rejected_evaluation.update(status: 'rejected')
      @rejected_evaluation.push(rejected_evaluation)
      evaluation_rejected_notify_recipient(rejected_evaluation, rejected_evaluation.created_by, current_user,
                                            EvaluationRejectedNotification)
    end
    users = User.all_hrs
    EvaluationMailer.evaluation_rejected(current_user, users.pluck(:email), @rejected_evaluation).deliver_later
    render_format
  end

  def evaluation_feed_back
    @user_hr = User.all_hrs
    @evaluations_status = nil
    params[:result]&.each do |t|
      question_id = t[1].values[0]
      evaluation_id = t[1].values[2]
      questiontype  = t[1].values[3]
      @evaluation_status = Evaluation.find(evaluation_id.to_i)
      @assigned_user = @evaluation_status.assigned_users.find_by(user_id: current_user.id)
      if questiontype == 'mcqs'
        answer_id = t[1].values[1]
        EvaluationFeedBack.create!(assigned_user_id: @assigned_user.id, evaluation_option_id: answer_id,
                                    question_id:)
      else
        feedback = t[1].values[1]
        EvaluationFeedBack.create!(assigned_user_id: @assigned_user.id, feedback:, question_id:)
      end
    end
    flash[:notice] = 'Your Evalution has been submitted Successfully'
    feedback_notify_recipient(@evaluation_status, @assigned_user, EvaluationCompletedNotification)
    @user_hr.each do |hr|
      EvaluationMailer.evaluation_completed(hr.email, @assigned_user.user.email,
                                            @evaluation_status.title).deliver_later
    end
  end

  def redirect_to_path(*args)
    request_status = args[0]
    respond_to do |format|
      if request_status == 'true'
        format.html { redirect_to args[1], notice: args[2] }
        format.json { render :show, status: :created, location: @evaluation }
      else
        format.html { render params[:action] == 'create' ? :new : :edit, status: :unprocessable_entity }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end
end
