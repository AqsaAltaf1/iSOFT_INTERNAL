class AddTimeFieldToLeave < ActiveRecord::Migration[7.0]
  def change
    add_column :leaves, :from_time, :time
    add_column :leaves, :to_time, :time
  end
end
