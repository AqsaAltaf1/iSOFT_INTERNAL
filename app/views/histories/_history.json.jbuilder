# frozen_string_literal: true

json.extract! history, :id, :created_at, :updated_at
json.url history_url(history, format: :json)
