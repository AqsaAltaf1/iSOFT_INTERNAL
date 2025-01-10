# frozen_string_literal: true

class RemoveDateFromTimeSheets < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_sheets, :date, :string
  end
end
