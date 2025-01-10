# frozen_string_literal: true

class EvaluationOption < ApplicationRecord
  acts_as_tenant :company
  # belongs_to :question
  has_many :evaluation_feed_backs, dependent: :destroy
end
