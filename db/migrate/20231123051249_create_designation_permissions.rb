# frozen_string_literal: true

class CreateDesignationPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :designations_permissions do |t|
      t.references :designation, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
