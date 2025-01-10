# frozen_string_literal: true

class AddEvaluationIdToEvaluationFeedBacks < ActiveRecord::Migration[7.0]
  def change
    add_reference :evaluation_feed_backs, :evaluation, null: false, foreign_key: true
  end
end