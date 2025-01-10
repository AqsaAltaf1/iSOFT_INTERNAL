# frozen_string_literal: true

class AddShortTypeToLeaves < ActiveRecord::Migration[7.0]
  def change
    add_column :leaves, :short_type, :integer, default: nil
  end
end
