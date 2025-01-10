# To deliver this notification:
#
# RequestNotification.with(post: @post).deliver_later(current_user)
# RequestNotification.with(post: @post).deliver(current_user)

class RequestNotification < Noticed::Base
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
      "<strong>#{params[:user].full_name}</strong> has  submitted a <strong>#{params[:request].request_type}</strong> request".html_safe
    else
      "You have successfully been submitted <strong>#{params[:request].request_type}</strong> Request for approval".html_safe
    end
  end

  def url
    request_path(Request.find(params[:request].id), notification_id: params[:request].id)
  end
end
