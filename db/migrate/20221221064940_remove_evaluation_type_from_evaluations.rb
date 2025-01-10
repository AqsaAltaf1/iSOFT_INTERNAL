# frozen_string_literal: true

class RemoveEvaluationTypeFromEvaluations < ActiveRecord::Migration[7.0]
  def change
    remove_column :evaluations, :evaluation_type, :integer
  end
end
