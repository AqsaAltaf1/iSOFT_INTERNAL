# frozen_string_literal: true

class CreateCompanyAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :company_assets do |t|
      t.string :model
      t.string :type
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
