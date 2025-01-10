# frozen_string_literal: true

class Question < ApplicationRecord
  acts_as_tenant :company
  validates_presence_of :question
  validate :question_type_cannot_be_changed, on: :update
  validates :question, presence: true
  # validates :evaluation_options, length: { minimum: 2, maximum: 4 }, on: [:create, :update]
  belongs_to :evaluation
  enum question_type: %i[question mcqs]
  has_many :evaluation_options, dependent: :destroy
  has_many :evaluation_feed_backs, dependent: :destroy
  accepts_nested_attributes_for :evaluation_options, allow_destroy: true, reject_if: lambda { |attrs|
                                                                                       attrs['option'].blank?
                                                                                     }
  def question_type_cannot_be_changed
    errors.add(:question_type, "can't be changed") if question_type_changed?
  end
end
