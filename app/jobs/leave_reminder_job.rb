# frozen_string_literal: true

class LeaveReminderJob < ApplicationJob
  queue_as :default
  def perform
    @leaves_reminder = Leave.where(status: 'pending').where('created_at < ?', Time.now - 24.hours)
    @leaves_reminder.each do |leave|
      if leave.user.is_hr
        @users = User.where(user_type: %w[admin])
      elsif leave.user.user?
        @users = User.where(user_type: admin) + User.all_hrs
      end
      @users.each do |user|
        LeaveMailer.leave_reminder_email(leave, User.find(leave.user_id), user).deliver_later
        LeaveReminderNotification.with(leave:, user: User.find(leave.user_id), admin_or_hr: user).deliver(user)
        notifications = Notification.where(recipient: user).newest_first.limit(9)
        @unread = notifications.unread
        @read = notifications.read
        SendNotificationJob.perform_later(@unread.first, user, @read.count)
      end
    end
  end
end
