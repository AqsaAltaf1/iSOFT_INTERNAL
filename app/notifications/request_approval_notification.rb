# To deliver this notification:
#
# RequestApprovalNotification.with(post: @post).deliver_later(current_user)
# RequestApprovalNotification.with(post: @post).deliver(current_user)

class RequestApprovalNotification < Noticed::Base
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
        "You have #{params[:request].status} the request of <strong>#{params[:user].full_name}</strong>".html_safe
      else
        "<strong>#{params[:admin_or_hr].full_name}</strong> has #{params[:request].status} the request of <strong>#{params[:user].full_name}</strong>".html_safe
      end
    else
      "<strong>#{params[:user].full_name}</strong> has #{params[:request].status} Your Request".html_safe
    end
  end

  def url
    if params[:admin_or_hr].present?
      request_path(Request.find(params[:request].id), notification_id: params[:request].id, checked_by: params[:admin_or_hr])
    else
      request_path(Request.find(params[:request].id), notification_id: params[:request].id)
    end
  end
end
