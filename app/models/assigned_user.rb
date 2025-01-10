# frozen_string_literal: true

class AssignedUser < ApplicationRecord
  acts_as_tenant :company
  belongs_to :user
  belongs_to :evaluation
  has_one :evaluation_feed_back
end
