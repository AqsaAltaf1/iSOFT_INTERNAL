# frozen_string_literal: true

class AddProjectIdToTimeSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :project_id, :integer
  end
end
