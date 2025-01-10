# app/models/concerns/notification_data.rb
# frozen_string_literal: true

# concern for notifications data
module NotificationData
  def set_date(date)
    date.at_beginning_of_week.strftime('%B %d').to_s << ' to ' << date.at_end_of_week.strftime('%B %d').to_s
  end
end
