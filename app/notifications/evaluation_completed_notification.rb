# app/notifications/evaluation_completed_notification.rb
# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# Notification after evaluation is completed by the employee
class EvaluationCompletedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    if params[:hr].present?
      "<strong>#{params[:user].user.full_name}</strong> has  Completed the <strong>#{params[:evaluation].title}</strong> Evaluation".html_safe
    end
  end

  def url
    completed_evaluation_evaluations_path(evaluation_notification: params[:evaluation].id, assigned_user: params[:user])
  end
end
