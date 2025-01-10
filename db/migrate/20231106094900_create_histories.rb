# frozen_string_literal: true

class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.references :company_asset, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :given_date
      t.date :return_date

      t.timestamps
    end
  end
end
