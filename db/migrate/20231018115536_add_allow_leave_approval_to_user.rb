# frozen_string_literal: true

class AddAllowLeaveApprovalToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :allow_leave_approval, :integer, default: 0
  end
end
