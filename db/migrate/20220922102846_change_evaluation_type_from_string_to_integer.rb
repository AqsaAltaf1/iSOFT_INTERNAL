# frozen_string_literal: true

class ChangeEvaluationTypeFromStringToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :evaluations, :evaluation_type, :integer, using: 'evaluation_type::integer'
  end
end
