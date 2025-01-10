# frozen_string_literal: true

class ChangeNullConstraintToCompanyAsset < ActiveRecord::Migration[7.0]
  def change
    change_column :company_assets, :user_id, :bigint, null: true
  end
end
