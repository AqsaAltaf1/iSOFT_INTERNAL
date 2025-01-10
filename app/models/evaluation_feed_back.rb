# frozen_string_literal: true

class EvaluationFeedBack < ApplicationRecord
  acts_as_tenant :company
  # belongs_to :user
  # belongs_to :evaluation
  belongs_to :evaluation_option, optional: true
  belongs_to :assigned_user
  belongs_to :question
  scope :for_assigned_user_and_questions, lambda { |assigned_user_id, question_ids|
    includes(:question, :evaluation_option)
      .where(assigned_user_id:, question_id: question_ids)
  }
end
