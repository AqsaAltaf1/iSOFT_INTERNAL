# frozen_string_literal: true

class AddColumnsToCompanyAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :histories, :assigned_by, :string
    add_column :company_assets, :purchase_date, :date
    add_column :company_assets, :status, :integer, default: 0
    add_column :company_assets, :price, :decimal
  end
end
