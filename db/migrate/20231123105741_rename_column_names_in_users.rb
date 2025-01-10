# frozen_string_literal: true

class RenameColumnNamesInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :user_type, :employment_type
    rename_column :users, :role, :user_type
  end
end
