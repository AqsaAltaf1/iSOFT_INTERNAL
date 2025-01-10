# frozen_string_literal: true

class AddFieldsToCompanyAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :company_assets, :given_date, :date
    add_column :company_assets, :return_date, :date
    add_column :company_assets, :added_by, :string
  end
end
