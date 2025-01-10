# frozen_string_literal: true

class Announcement < ApplicationRecord
  acts_as_tenant :company
  has_many_attached :files
  validates :title, presence: true
  validates :body, presence: true
  has_noticed_notifications model_name: 'Notification'
  # scope :desc, order("announcements.created_at DESC")
end
