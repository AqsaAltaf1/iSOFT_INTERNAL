# frozen_string_literal: true

module Evaluation::CallBackModule
  include ActiveSupport::Concern

  def check_user_feedback
    @evaluation = Evaluation.find(params[:evaluation_notification])
    authorize @evaluation
    if @evaluation.assigned_users.joins(:evaluation_feed_back).where(user_id: current_user.id).exists?
      redirect_to user_evaluation_evaluations_path
    end
  end

  def prevent_approved_active
    @evaluation = Evaluation.find(params[:id])
    if @evaluation.status == 'approved' || @evaluation.status == 'active' || @evaluation.status == 'rejected'
      redirect_to evaluations_path, alert: 'You Can Not Edit Evaluation with Approved , Active or Rejected Status.'
    end
  end

  def assigned_user
    if params[:evaluation][:user_ids].present?
      user_ids = params[:evaluation][:user_ids].reject { |item| item.nil? || item.empty? }.map(&:to_i)
      user_ids.each do |user|
        AssignedUser.create(user_id: user, evaluation_id: @evaluation.id)
      end
    end
  end

  def render_format
    if (params[:evaluation_status] || params[:status] || params[:evaluations_status_update]) && !params[:evaluation_notification]
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end
end
