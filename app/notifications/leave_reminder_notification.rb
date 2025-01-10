# frozen_string_literal: true

# To deliver this notification:
#
# LeaveReminderNotification.with(post: @post).deliver_later(current_user)
# LeaveReminderNotification.with(post: @post).deliver(current_user)

class LeaveReminderNotification < Noticed::Base
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
      "<strong>Reminder: #{params[:user].full_name}</strong> has  submitted a leave request".html_safe
    else
      'You have successfully been submitted Leave Request for approval'.html_safe
    end
  end

  def url
    leave_path(Leave.find(params[:leave].id), notification_id: params[:leave].id)
  end
end
