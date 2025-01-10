# frozen_string_literal: true

# To deliver this notification:
#
# AnnouncementNotification.with(post: @post).deliver_later(current_user)
# AnnouncementNotification.with(post: @post).deliver(current_user)

class AnnouncementNotification < Noticed::Base
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
    "<strong>New Announcement</strong> by #{params[:user].full_name}".html_safe
  end

  def url
    announcement_path(params[:announcement].id, notification_id: params[:announcement].id)
  end
end
