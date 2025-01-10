# frozen_string_literal: true

class ChangeDesignationFromStringToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :designation, :integer, using: 'designation::integer'
  end

  def down
    change_column :users, :designation, :integer, using: 'designation::integer'
  end
end
