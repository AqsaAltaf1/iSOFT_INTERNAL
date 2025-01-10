# frozen_string_literal: true

class AddRequestLeavesToLeave < ActiveRecord::Migration[7.0]
  def change
    add_column :leaves, :request_leaves, :integer, default: 0
  end
end
