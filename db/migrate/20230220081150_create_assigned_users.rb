# frozen_string_literal: true

class CreateAssignedUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :evaluation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
