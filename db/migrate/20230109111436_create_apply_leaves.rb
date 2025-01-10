# frozen_string_literal: true

class CreateApplyLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :apply_leaves do |t|
      t.string :allowed_leave_type
      t.integer :allowed_day

      t.timestamps
    end
  end
end
