# frozen_string_literal: true

class Evaluation < ApplicationRecord
  acts_as_tenant :company
  validates :title, presence: true
  validates :questions, presence: { message: 'Please Enter Atleast One Question.' }, allow_blank: false
  has_many :questions, dependent: :destroy
  # has_many :evaluation_feed_backs
  # has_many :users, through: :evaluation_feed_backs
  has_many :assigned_users, dependent: :destroy
  has_many :users, through: :assigned_users, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: ->(attrs) { attrs['question'].blank? }
  enum status: %i[pending approved active completed rejected], _default: 'pending'
  has_noticed_notifications model_name: 'Notification'
  scope :searched_evaluations, ->(search_word) { where('title ILIKE ?', "%#{search_word}%") }
  scope :user_evaluations, lambda { |current_user|
                             where.not(id: current_user.assigned_users.joins(:evaluation_feed_back).pluck(:evaluation_id).uniq).where(status: 'active')
                           }
  scope :status, ->(status) { where(status:) }
end
