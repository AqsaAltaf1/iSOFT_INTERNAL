# frozen_string_literal: true

json.extract! company_asset, :id, :model, :type, :name, :user_id, :created_at, :updated_at
json.url company_asset_url(company_asset, format: :json)
