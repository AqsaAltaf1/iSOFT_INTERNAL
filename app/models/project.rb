# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_tenant :company
  validates :name, presence: true
  validates :description, presence: true
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  scope :searched_projects, lambda { |search_word|
                              where('name ILIKE ? OR description ILIKE ?', "%#{search_word}%", "%#{search_word}%")
                            }
end
