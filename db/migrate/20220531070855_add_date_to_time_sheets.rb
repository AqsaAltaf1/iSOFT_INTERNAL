# frozen_string_literal: true

class AddDateToTimeSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :date, :datetime
  end
end
