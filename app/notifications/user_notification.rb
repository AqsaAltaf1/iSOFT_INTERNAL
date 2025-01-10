# frozen_string_literal: true

# To deliver this notification:
#
# UserNotification.with(post: @post).deliver_later(current_user)
# UserNotification.with(post: @post).deliver(current_user)

class UserNotification < Noticed::Base
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

  def message
    "<strong>#{params[:user].full_name}</strong> has created a user".html_safe
  end

  def url
    user_path(User.find(params[:created_user].id), notification_id: params[:user].id)
  end
end
