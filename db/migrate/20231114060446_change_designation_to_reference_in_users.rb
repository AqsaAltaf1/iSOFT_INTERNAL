# frozen_string_literal: true

class ChangeDesignationToReferenceInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :designation, :integer # Remove existing integer column

    add_reference :users, :designation, foreign_key: true # Add reference to designations table
  end
end
