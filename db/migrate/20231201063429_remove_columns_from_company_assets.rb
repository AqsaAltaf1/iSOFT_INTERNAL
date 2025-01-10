# frozen_string_literal: true

class RemoveColumnsFromCompanyAssets < ActiveRecord::Migration[7.0]
  def change
    remove_column :company_assets, :given_date, :date
    remove_column :company_assets, :return_date, :date
  end
end
