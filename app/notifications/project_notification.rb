# frozen_string_literal: true

# To deliver this notification:
#
# ProjectNotification.with(post: @post).deliver_later(current_user)
# ProjectNotification.with(post: @post).deliver(current_user)

class ProjectNotification < Noticed::Base
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
    "<strong>#{params[:user].full_name}</strong> has assigned you a project <strong>#{params[:project].name}</strong>".html_safe
  end

  def url
    project_path(Project.find(params[:project].id), notification_id: params[:project].id)
  end
end
