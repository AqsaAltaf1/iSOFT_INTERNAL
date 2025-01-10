# app/notifications/evaluation_approval_notification.rb
# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# Notification for approved evaluation
class EvaluationRejectedNotification < Noticed::Base
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
    if params[:admin].present?
      "<strong>#{params[:admin]&.full_name}</strong> has successfully Rejected Your <strong>#{params[:evaluation].title}</strong> Evaluation".html_safe
    end
  end

  def url
    evaluations_path(status: params[:evaluation].status, evaluation_notification: params[:evaluation].id)
  end
end
