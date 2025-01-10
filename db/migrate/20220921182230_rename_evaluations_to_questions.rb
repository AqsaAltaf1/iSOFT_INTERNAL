# frozen_string_literal: true

class RenameEvaluationsToQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.string :type
      t.integer :status
      t.string :title

      t.timestamps
    end
  end
end
