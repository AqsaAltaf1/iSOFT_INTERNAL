# app/channels/web_notifications_channel.rb
# frozen_string_literal: true

# subscribtion channel for notifications to the user logged-in
class WebNotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
