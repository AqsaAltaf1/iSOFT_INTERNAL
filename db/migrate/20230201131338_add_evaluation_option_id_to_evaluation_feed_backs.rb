# frozen_string_literal: true

class AddEvaluationOptionIdToEvaluationFeedBacks < ActiveRecord::Migration[7.0]
  def change
    unless EvaluationFeedBack.column_names.include?('evaluation_option_id')
      add_column :evaluation_feed_backs, :evaluation_option_id,
                 :bigint
    end
  end
end
