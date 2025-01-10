# app/notifications/leave_approval_notification.rb
# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# Notification after leave of an employee has been approved
class LeaveApprovalNotification < Noticed::Base
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
    if params[:admin_or_hr].present?
      if params[:current_user]
        "You have #{params[:leave].status} the leave of <strong>#{params[:user].full_name}</strong>".html_safe
      else
        "<strong>#{params[:admin_or_hr].full_name}</strong> has #{params[:leave].status} the leave of <strong>#{params[:user].full_name}</strong>".html_safe
      end
    else
      "<strong>#{params[:user].full_name}</strong> has #{params[:leave].status} Your Leave".html_safe
    end
  end

  def url
    if params[:admin_or_hr].present?
      leave_path(Leave.find(params[:leave].id), notification_id: params[:leave].id, checked_by: params[:admin_or_hr])
    else
      leave_path(Leave.find(params[:leave].id), notification_id: params[:leave].id)
    end
  end
end
