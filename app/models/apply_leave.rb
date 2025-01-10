# frozen_string_literal: true

class ApplyLeave < ApplicationRecord
  acts_as_tenant :company
  has_many :leaves, dependent: :destroy
  validates :allowed_leave_type, presence: true, uniqueness: true
  validates :allowed_day, presence: true, if: proc { |a| a.allowed_leave_type != 'short'}
  validates :allowed_hours, presence: true, if: proc { |a| a.allowed_leave_type == 'short'}
  before_validation :normalize_name
  enum :paid_type, %i[paid unpaid]


  def self.remaining_leaves_of_type(type, user)
    allowed_day = find(type).allowed_day
    approved_leaves = user.leaves.with_deleted.selected_leaves('approved').selected_type(type)
    allowed_day - approved_leaves.sum(:request_leaves)
  end

  def self.remaining_leaves_of_short_type(type, user)
    allowed_hours = find(type).allowed_hours
    approved_leaves = user.leaves.with_deleted.selected_leaves('approved').selected_type(type)
    allowed_hours - approved_leaves.sum(:hours)
  end

  def normalize_name
    self.allowed_leave_type = self.allowed_leave_type.downcase
  end

  def self.all_types
    paid_types.keys.map { |type| [type.humanize, type] }
  end

end
