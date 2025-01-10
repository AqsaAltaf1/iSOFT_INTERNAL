# frozen_string_literal: true

class AddStatusAndDesignationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :status, :integer, default: 0
    # Ex:- :default =>''
    add_column :users, :designation, :string
  end
end
