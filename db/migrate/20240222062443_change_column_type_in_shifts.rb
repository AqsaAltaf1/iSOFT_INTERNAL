class ChangeColumnTypeInShifts < ActiveRecord::Migration[7.0]
  def up
    change_column :shifts, :start_time, :time
    change_column :shifts, :end_time, :time
  end

  def down
    change_column :shifts, :start_time, :datetime
    change_column :shifts, :end_time, :datetime
  end
end
