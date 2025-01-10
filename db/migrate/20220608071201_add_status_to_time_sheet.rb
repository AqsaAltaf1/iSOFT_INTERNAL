# frozen_string_literal: true

class AddStatusToTimeSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :status, :integer, default: 0
  end
end
