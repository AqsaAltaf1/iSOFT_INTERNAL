# app/jobs/send_notification_job.rb
# frozen_string_literal: true

# send notification jobs
class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification, current_user, read_count)
    html = ApplicationController.render(
      partial: 'user/notification',
      locals: { notification:, current_user:, read_count: }
    )
    WebNotificationsChannel.broadcast_to(
      current_user,
      html:
    )
  end
end
