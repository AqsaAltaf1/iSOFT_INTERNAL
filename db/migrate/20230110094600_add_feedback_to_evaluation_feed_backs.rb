# frozen_string_literal: true

class AddFeedbackToEvaluationFeedBacks < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluation_feed_backs, :feedback, :text
  end
end
