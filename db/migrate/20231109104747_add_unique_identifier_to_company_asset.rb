# frozen_string_literal: true

class AddUniqueIdentifierToCompanyAsset < ActiveRecord::Migration[7.0]
  def change
    add_column :company_assets, :unique_identifier, :string
  end
end
