# frozen_string_literal: true

class RenameTypeColumnInCompanyAssets < ActiveRecord::Migration[7.0]
  def change
    rename_column :company_assets, :type, :company_assets_type
  end
end
