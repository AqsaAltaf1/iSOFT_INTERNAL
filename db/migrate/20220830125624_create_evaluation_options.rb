# frozen_string_literal: true

class CreateEvaluationOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluation_options do |t|
      t.string :option
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
