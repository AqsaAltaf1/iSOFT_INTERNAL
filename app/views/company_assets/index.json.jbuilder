# frozen_string_literal: true

json.array! @company_assets, partial: 'company_assets/company_asset', as: :company_asset
