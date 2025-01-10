# frozen_string_literal: true

class AddDeletedAtToLeave < ActiveRecord::Migration[7.0]
  def change
    add_column :leaves, :deleted_at, :datetime
    add_index :leaves, :deleted_at
  end
end
