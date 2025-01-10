# app/notifications/evaluation_notification.rb
# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# Notification after HR submits evaluation to admin for approval
class EvaluationNotification < Noticed::Base
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
    if params[:adm].present?
      @user = User.find_by(id: params[:user])
      "<strong>#{@user.full_name}</strong> has  submitted <strong>#{params[:evaluation].title}</strong> Evaluation  for approval".html_safe
    end
  end

  def url
    evaluations_path(status: params[:evaluation].status, evaluation_notification: params[:evaluation].id)
  end
end
