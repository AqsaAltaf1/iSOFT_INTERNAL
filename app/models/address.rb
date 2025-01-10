# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user, dependent: :destroy
  # validates :street, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :zip, presence: true
  # validates :country, presence: true
  acts_as_tenant :company
end
