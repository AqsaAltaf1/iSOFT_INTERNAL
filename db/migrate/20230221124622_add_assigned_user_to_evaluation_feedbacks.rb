# frozen_string_literal: true

class AddAssignedUserToEvaluationFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_reference :evaluation_feed_backs, :assigned_user, null: false, foreign_key: true
  end
end
