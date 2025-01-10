# app/notifications/time_sheet_approvel_notification.rb

# frozen_string_literal: true

# To deliver this notification:
#
# TimeSheetApprovelNotification.with(post: @post).deliver_later(current_user)
# TimeSheetApprovelNotification.with(post: @post).deliver(current_user)
include NotificationData

# notification when a time sheet being submitted by employee has been approved
class TimeSheetApprovelNotification < Noticed::Base
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
        "You have successfully <strong>#{params[:time_sheet].status}</strong> TimeSheet of the <strong>#{params[:user].full_name}</strong> for week <strong>#{set_date(params[:time_sheet].date)}</strong>".html_safe
      else
        "<strong>#{params[:admin_or_hr].full_name}</strong> has successfully <strong>#{params[:time_sheet].status}</strong> TimeSheet of the <strong>#{params[:user].full_name}</strong> for week <strong>#{set_date(params[:time_sheet].date)}</strong>".html_safe
      end
    else
      "<strong>#{params[:user].full_name}</strong> has <strong>#{params[:time_sheet].status}</strong> Your TimeSheet for week <strong>#{set_date(params[:time_sheet].date)}</strong>".html_safe
    end
  end

  def url
    if params[:admin_or_hr].present?
      time_sheets_path(n_time_sheet: params[:time_sheet].id, user_id: params[:user].id,
                       status: params[:time_sheet].status, data: params[:time_sheet].date.strftime('%A'))
    else
      time_sheets_path(n_time_sheet: params[:time_sheet].id, status: params[:time_sheet].status,
                       data: params[:time_sheet].date.strftime('%A'))
    end
  end
end
