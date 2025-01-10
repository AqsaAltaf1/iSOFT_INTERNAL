# frozen_string_literal: true

class RemoveUserIDandEvaluationIdFromEvaluationFeedBacks < ActiveRecord::Migration[7.0]
  def change
    remove_reference :evaluation_feed_backs, :user, null: false, foreign_key: true
    remove_column :evaluation_feed_backs, :evaluation_id, :bigint
  end
end
