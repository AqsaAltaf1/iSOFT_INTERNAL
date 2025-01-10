# frozen_string_literal: true

json.extract! help_document, :id, :name, :created_at, :updated_at
json.url help_document_url(help_document, format: :json)
