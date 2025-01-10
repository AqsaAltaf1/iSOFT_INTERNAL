# frozen_string_literal: true

class AddEvaluationIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :evaluation, foreign_key: true
  end
end
