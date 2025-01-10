# frozen_string_literal: true

class CreateUpcomingHolidays < ActiveRecord::Migration[7.0]
  def change
    create_table :upcoming_holidays do |t|
      t.string :title
      t.datetime :date
      t.text :description

      t.timestamps
    end
  end
end
