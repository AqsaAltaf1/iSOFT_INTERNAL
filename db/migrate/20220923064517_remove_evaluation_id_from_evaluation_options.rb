# frozen_string_literal: true

class RemoveEvaluationIdFromEvaluationOptions < ActiveRecord::Migration[7.0]
  def change
    # remove_column :evaluation_options, :evaluation_id, :bigint
  end
end
