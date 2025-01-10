class ChangeTypeOfLeavesColumnIntegerToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :leaves, :hours, :float
    change_column :leaves, :request_leaves, :float
  end
end
