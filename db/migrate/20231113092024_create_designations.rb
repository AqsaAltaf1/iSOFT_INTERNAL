# frozen_string_literal: true

class CreateDesignations < ActiveRecord::Migration[7.0]
  def change
    create_table :designations do |t|
      t.string :name
      t.references :company, null: true, foreign_key: true

      t.timestamps
    end
  end
end
