# frozen_string_literal: true

json.extract! evaluation, :id, :type, :status, :title, :created_at, :updated_at
json.url evaluation_url(evaluation, format: :json)
