# frozen_string_literal: true

class CreateLeave < ActiveRecord::Migration[7.0]
  def change
    create_table :leaves do |t|
      t.datetime :date_from
      t.datetime :date_to
      t.integer :status, default: 0
      t.integer :leave_type, default: 0
      t.integer :hours

      t.timestamps
    end
  end
end
