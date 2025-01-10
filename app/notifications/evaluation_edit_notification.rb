# app/notifications/evaluation_edit_notification.rb
# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# notification for editing evaluation
class EvaluationEditNotification < Noticed::Base
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
    if params[:hr].present? || params[:admin].present?
      "<strong>#{params[:user].full_name}</strong> has  Edited <strong>#{params[:evaluation].title}</strong> Evaluation.".html_safe
    end
  end

  def url
    evaluation_path(id: params[:evaluation].id, evaluation_notification: params[:evaluation].id)
  end
end
