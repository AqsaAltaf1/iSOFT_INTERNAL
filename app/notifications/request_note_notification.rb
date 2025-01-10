# To deliver this notification:
#
# RequestNoteNotification.with(post: @post).deliver_later(current_user)
# RequestNoteNotification.with(post: @post).deliver(current_user)

class RequestNoteNotification < Noticed::Base
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
    "<strong>Reminder: #{params[:sender].full_name}</strong> has  added a note".html_safe if params[:sender].present?
  end

  def url
    request_path(Request.find(params[:request].id), notification_id: params[:request].id)
  end
end
