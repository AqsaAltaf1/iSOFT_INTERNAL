# frozen_string_literal: true

class AddTimeToTimeSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :time, :datetime
  end
end
