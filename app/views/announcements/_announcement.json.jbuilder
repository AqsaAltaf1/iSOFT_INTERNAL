# frozen_string_literal: true

json.extract! announcement, :id, :title, :body, :created_at, :updated_at
json.url announcement_url(announcement, format: :json)
