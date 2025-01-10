# app/controllers/concerns/notify.rb
# frozen_string_literal: true

# concern for avtions of notifying users, inside application controller
module Notify
  def get_notifications(user)
    notifications = Notification.where(recipient: user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  def notify_recipient(time_sheet, employee, type)
    @time_sheet = time_sheet
    type.with(time_sheet: @time_sheet, user: current_user, admin_or_hr: nil).deliver(employee)
    get_notifications(employee)
    SendNotificationJob.perform_later(@unread.first, employee, @read.count)
    users = User.where(user_type: %w[admin]) + User.all_hrs
    users.each do |user|
      if user == current_user
        type.with(time_sheet: @time_sheet, user: employee, admin_or_hr: user, current_user: true).deliver(user)
      else
        type.with(time_sheet: @time_sheet, user: employee, admin_or_hr: current_user,
                  current_user: false).deliver(user)
      end
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

  def evaluation_notify_recipient(evaluation, evaluation_user, type)
    @evaluation = evaluation
    @user = User.find_by(id: evaluation_user)
    if !current_user.is_hr
      type.with(evaluation: @evaluation, user: @user, admin: current_user).deliver(@user)
      get_notifications(@user)
      SendNotificationJob.perform_later(@unread.first, @user, @read.count)
    else
      evaluationusers = User.where(user_type: 'admin')
      evaluationusers.each do |evaluationuser|
        type.with(evaluation: @evaluation, user: evaluation_user, adm: evaluationuser).deliver(evaluationuser)
        get_notifications(evaluationuser)
        SendNotificationJob.perform_later(@unread.first, evaluationuser, @read.count)
      end
    end
  end

  def feedback_notify_recipient(feed_back, feed_back_user, type)
    @feed_back = feed_back
    @user = feed_back_user
    feed_backusers = User.all_hrs
    feed_backusers.each do |feed_backuser|
      type.with(evaluation: @feed_back, user: @user, hr: feed_backuser).deliver(feed_backuser)
      get_notifications(feed_backuser)
      SendNotificationJob.perform_later(@unread.first, feed_backuser, @read.count)
    end
  end

  def evaluation_approve_notify_recipient(evaluation, admin, hrs, type)
    @approve_evaluation = evaluation
    @admin = admin
    @hrs = hrs
    @hrs.each do |hr|
      type.with(evaluation: @approve_evaluation, user: hr, admin: @admin).deliver(hr)
      get_notifications(hr)
      SendNotificationJob.perform_later(@unread.first, hr, @read.count)
    end
  end

  def evaluation_active_notify_recipient(evaluation, hr, users, type)
    @evaluation = evaluation
    @hr_user = hr
    @users = users
    users.each do |user|
      type.with(evaluation: @evaluation, user:, hr: @hr_user).deliver(user)
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

  def evaluation_rejected_notify_recipient(evaluation, hr_id, admin, type)
    @evaluation = evaluation
    hr = User.find_by(id: hr_id)
    @admin = admin
    type.with(evaluation: @evaluation, admin: @admin, hr:).deliver(hr)
    get_notifications(hr)
    SendNotificationJob.perform_later(@unread.first, hr, @read.count)
  end

  def evaluation_edit_notify_recipient(evaluation, evaluation_user, type)
    @evltion = evaluation
    @evaluation_user = evaluation_user
    if !current_user.admin?
      admin_users = User.where(user_type: 'admin')
      admin_users.each do |admin_user|
        type.with(evaluation: @evltion, user: @evaluation_user, admin: admin_user).deliver(admin_user)
        get_notifications(admin_user)
        SendNotificationJob.perform_later(@unread.first, admin_user, @read.count)
      end
    else
      hr_users = User.all_hrs
      hr_users.each do |hr_user|
        type.with(evaluation: @evltion, user: @evaluation_user, hr: hr_user).deliver(hr_user)
        get_notifications(hr_user)
        SendNotificationJob.perform_later(@unread.first, hr_user, @read.count)
      end
    end
  end

  def evaluation_destroy_notify_recipient(evaluation_title, evaluation_user, type)
    @evaluation_title = evaluation_title
    @evaluation_user = evaluation_user
    if !current_user.admin?
      admin_users = User.where(user_type: 'admin')
      admin_users.each do |admin_user|
        type.with(evaluation_title: @evaluation_title, user: @evaluation_user, admin: admin_user).deliver(admin_user)
        get_notifications(admin_user)
        SendNotificationJob.perform_later(@unread.first, admin_user, @read.count)
      end
    else
      hr_users = User.all_hrs
      hr_users.each do |hr_user|
        type.with(evaluation_title: @evaluation_title, user: @evaluation_user, hr: hr_user).deliver(hr_user)
        get_notifications(hr_user)
        SendNotificationJob.perform_later(@unread.first, hr_user, @read.count)
      end
    end
  end

  def announcement_notify_recipient(announcement, announcement_user, type)
    announcementusers = User.where.not(id: announcement_user.id)
    announcementusers.each do |user|
      type.with(announcement:, user: announcement_user).deliver(user)
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

  def leave_note_notifications(leave, sender, receivers, type)
    receivers = Array(receivers)
    receivers.each do |receiver|
      type.with(leave:, sender:, receiver:).deliver(receiver)
      get_notifications(receiver)
      SendNotificationJob.perform_later(@unread.first, receiver, @read.count)
    end
  end

  def request_note_notifications(request, sender, receivers, type)
    receivers = Array(receivers)
    receivers.each do |receiver|
      type.with(request:, sender:, receiver:).deliver(receiver)
      get_notifications(receiver)
      SendNotificationJob.perform_later(@unread.first, receiver, @read.count)
    end
  end

  def evaluation_note_notifications(evaluation, sender, receivers, type)
    receivers = Array(receivers)
    receivers.each do |receiver|
      type.with(evaluation:, sender:, receiver:).deliver(receiver)
      get_notifications(receiver)
      SendNotificationJob.perform_later(@unread.first, receiver, @read.count)
    end
  end

  def request_notify_recipient(request, employee, type)
    type.with(request: request, user: current_user, admin_or_hr: nil).deliver(employee)
    get_notifications(employee)
    SendNotificationJob.perform_later(@unread.first, employee, @read.count)
    users = User.where(user_type: %w[admin]) + User.all_hrs
    users.each do |user|
      if user == current_user
        unless employee.is_hr
          type.with(request: request, user: employee, admin_or_hr: user, current_user: true).deliver(user)
        end
      else
        type.with(request: request, user: employee, admin_or_hr: current_user,
                  current_user: false).deliver(user)
      end
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

end
