# frozen_string_literal: true

json.array! @upcoming_holidays, partial: 'upcoming_holidays/upcoming_holiday', as: :upcoming_holiday
