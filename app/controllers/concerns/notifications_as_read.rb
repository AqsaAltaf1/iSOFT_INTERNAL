# app/controllers/concerns/notifications_as_read.rb
# frozen_string_literal: true

# concern for notifications, inside application controller
module NotificationsAsRead
  def mark_project_notifications_as_read
    if current_user && params[:notification_id]
      @project = Project.find_by(id: params[:notification_id])
      notifications_to_mark_as_read = @project&.notifications_as_project&.where(recipient: current_user)
      notifications_to_mark_as_read&.update_all(read_at: Time.zone.now)
    end
  end

  def mark_user_notifications_as_read
    if current_user && params[:notification_id]
      @user = User.find(params[:notification_id])
      notifications_to_mark_as_read = @user.notifications_as_user.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def mark_time_sheet_notifications_as_read
    if current_user && params[:n_time_sheet]
      @time_sheet = TimeSheet.find(params[:n_time_sheet])
      # # @time_sheet = TimeSheet.where(date: (Date.today.at_beginning_of_week..Date.today.at_end_of_week))
      notifications_to_mark_as_read = @time_sheet.notifications_as_time_sheet.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def mark_leave_notifications_as_read
    if current_user && params[:notification_id]
      @leave = Leave.find(params[:notification_id])
      notifications_to_mark_as_read = @leave.notifications_as_leave.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def mark_evaluation_notifications_as_read
    if current_user && params[:evaluation_notification]
      @evaluation = Evaluation.find(params[:evaluation_notification])
      notifications_to_mark_as_read = @evaluation.notifications_as_evaluation.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def mark_evaluation_destroy_notifications_as_read
    if current_user && params[:is_delete]
      notify = current_user.notifications.where(params[:evaluation_title] == params[:is_delete])
      notify&.mark_as_read!
    end
  end

  def mark_announcement_notifications_as_read
    if current_user && params[:notification_id]
      @announcement = Announcement.find(params[:notification_id])
      notifications_to_mark_as_read = @announcement.notifications_as_announcement.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def mark_request_notifications_as_read
    if current_user && params[:notification_id]
      @request = Request.find(params[:notification_id])
      notifications_to_mark_as_read = @request.notifications_as_request.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
  
  def mark_history_notifications_as_read
    if current_user && params[:notification_id]
      @history = History.find(params[:notification_id])
      notifications_to_mark_as_read = @history.notifications_as_history.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
