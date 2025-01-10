# frozen_string_literal: true

class AddCreatedByToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :created_by, :integer
  end
end
