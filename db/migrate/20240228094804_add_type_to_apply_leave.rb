class AddTypeToApplyLeave < ActiveRecord::Migration[7.0]
  def change
    add_column :apply_leaves, :paid_type, :integer, default: 0
  end
end
