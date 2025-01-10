# frozen_string_literal: true

json.extract! upcoming_holiday, :id, :title, :date, :description, :created_at, :updated_at
json.url upcoming_holiday_url(upcoming_holiday, format: :json)
