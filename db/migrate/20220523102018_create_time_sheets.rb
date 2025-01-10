# frozen_string_literal: true

class CreateTimeSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :time_sheets do |t|
      t.float :time
      t.text :description

      t.timestamps
    end
  end
end
