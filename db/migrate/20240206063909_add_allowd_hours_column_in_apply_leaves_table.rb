class AddAllowdHoursColumnInApplyLeavesTable < ActiveRecord::Migration[7.0]
  def change
    add_column :apply_leaves, :allowed_hours, :float
  end
end
