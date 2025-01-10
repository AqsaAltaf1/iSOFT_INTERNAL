# frozen_string_literal: true

class AddDeletedAtToCompanyAsset < ActiveRecord::Migration[7.0]
  def change
    add_column :company_assets, :deleted_at, :datetime
    add_index :company_assets, :deleted_at
  end
end
