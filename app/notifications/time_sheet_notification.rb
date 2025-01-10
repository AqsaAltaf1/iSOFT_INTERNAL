# app/notifications/time_sheet_notification.rb

# frozen_string_literal: true

# To deliver this notification:
#
# TimeSheetNotification.with(post: @post).deliver_later(current_user)
# TimeSheetNotification.with(post: @post).deliver(current_user)
include NotificationData

# notification when an employee submits his/her timesheet
class TimeSheetNotification < Noticed::Base
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
      "<strong>#{params[:user].full_name}</strong> has  submitted a TimeSheet for week <strong>#{set_date(params[:time_sheet].date)}</strong>".html_safe
    else
      "You have successfully been submitted TimeSheet for approval  for week <strong>#{set_date(params[:time_sheet].date)}</strong>".html_safe
    end
  end

  def url
    if params[:admin_or_hr].present?
      if params[:time_sheet].status == 'pending'
        admins_data_path(date: params[:time_sheet].date, user_id: params[:user].id, n_time_sheet: params[:time_sheet])
      else
        admins_path(n_time_sheet: params[:time_sheet].id)
      end
    else
      time_sheets_path(n_time_sheet: params[:time_sheet].id, status: 'Pending',
                       data: params[:time_sheet].date.strftime('%A'))
    end
  end
end
