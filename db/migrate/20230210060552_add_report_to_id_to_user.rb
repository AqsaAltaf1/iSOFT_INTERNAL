# frozen_string_literal: true

class AddReportToIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :report_to_id, :integer
  end
end
