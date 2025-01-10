# frozen_string_literal: true

class AddDateToTimeSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :date, :string, default: Date.today
    # Ex:- :default =>''
  end
end
