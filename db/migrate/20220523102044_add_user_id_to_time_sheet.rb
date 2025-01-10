# frozen_string_literal: true

class AddUserIdToTimeSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :user_id, :integer
  end
end
