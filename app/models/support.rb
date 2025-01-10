# frozen_string_literal: true

class Support < ApplicationRecord
  acts_as_tenant :company
  belongs_to :user
  validates :email, :description, presence: true
end
