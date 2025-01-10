# To deliver this notification:
#
# HistoryNotification.with(post: @post).deliver_later(current_user)
# HistoryNotification.with(post: @post).deliver(current_user)

class HistoryNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :history

  # Define helper methods to make rendering easier.
  #
  def message
    "<strong>#{params[:history][:assigned_by]}</strong> has assigned you an asset".html_safe
  end

  def url
    history_path(History.find(params[:history].id), notification_id: params[:history].id)
  end
end
