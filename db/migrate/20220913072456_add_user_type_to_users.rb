# frozen_string_literal: true

class AddUserTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_type, :integer
  end
end
