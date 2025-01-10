# app/channels/application_cable/connection.rb
# frozen_string_literal: true

module ApplicationCable
  # connection for notifying authentic user
  class Connection < ActionCable::Connection::Base
    rescue_from StandardError, with: :report_error
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def report_error(error)
      SomeExternalBugtrackingService.notify(error)
    end

    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
