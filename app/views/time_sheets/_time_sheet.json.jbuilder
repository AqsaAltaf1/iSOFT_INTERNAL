# frozen_string_literal: true

json.extract! time_sheet, :id, :time, :description, :created_at, :updated_at
json.url time_sheet_url(time_sheet, format: :json)
