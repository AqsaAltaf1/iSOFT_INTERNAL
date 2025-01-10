# frozen_string_literal: true

class RemoveLeaveTypeFromLeaves < ActiveRecord::Migration[7.0]
  def change
    remove_column :leaves, :leave_type, :integer
  end
end
