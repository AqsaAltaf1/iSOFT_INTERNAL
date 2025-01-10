# frozen_string_literal: true

class Note < ApplicationRecord
  acts_as_tenant :company
  include Notify
  belongs_to :notable, polymorphic: true
  belongs_to :user

  after_create :send_notification

  def send_notification
    case notable_type
    when 'Leave'
      send_leave_note_notification
    when 'Evaluation'
      send_evaluation_note_notification
    when 'Request'
      send_request_note_notification
    end
  end

  private

  def send_leave_note_notification
    leave = notable
    sender = user
    if user.is_hr || (user.user_type == 'admin')
      receivers = notable.user
    else !user.is_hr || !(user.user_type == 'admin')
      receivers = (User.all_hrs + User.admin)
    end
    leave_note_notifications(leave, sender, receivers, LeaveNoteCreatedNotification)
  end

  def send_evaluation_note_notification
    evaluation = notable
    sender = user
    receivers = sender.user_type == 'admin' ? User.all_hrs : User.admin
    evaluation_note_notifications(evaluation, sender, receivers, EvaluationNoteCreatedNotification)
  end

  def send_request_note_notification
    request = notable
    sender = user
    if user.is_hr || (user.user_type == 'admin')
      receivers = notable.user
    else !user.is_hr || !(user.user_type == 'admin')
      receivers = (User.all_hrs + User.admin)
    end
    request_note_notifications(request, sender, receivers, RequestNoteNotification)
  end
end
