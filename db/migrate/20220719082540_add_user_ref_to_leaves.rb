# frozen_string_literal: true

class AddUserRefToLeaves < ActiveRecord::Migration[7.0]
  def change
    add_reference :leaves, :user, null: false, foreign_key: true
  end
end
