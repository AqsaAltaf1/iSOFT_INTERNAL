# frozen_string_literal: true

class LeaveNoteCreatedNotification < Noticed::Base
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
    if params[:sender] == params[:receiver]
      '<strong>Reminder: You</strong> have  added a note'.html_safe
    else
      "<strong>#{params[:sender].full_name}: </strong> have  added a note".html_safe
    end
  end

  def url
    leave_path(Leave.find(params[:leave].id), id: params[:leave].id, notification_id: params[:leave].id)
  end
end
