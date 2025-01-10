# frozen_string_literal: true

class RemoveTimeFromTimeSheets < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_sheets, :time, :string
  end
end
