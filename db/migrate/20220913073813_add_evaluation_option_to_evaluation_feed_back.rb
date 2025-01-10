# frozen_string_literal: true

class AddEvaluationOptionToEvaluationFeedBack < ActiveRecord::Migration[7.0]
  # def change
  #   add_reference :evaluation_feed_backs, :evaluation_options, null: false, foreign_key: true
  # end
  def up
    #   remove_reference :evaluation_feed_backs, :evaluation_options, null: false, foreign_key: true
  end

  def down
    add_reference :evaluation_feed_backs, :evaluation_options, null: false, foreign_key: true
  end
end
