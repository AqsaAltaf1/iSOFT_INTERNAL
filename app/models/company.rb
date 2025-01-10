# frozen_string_literal: true

class Company < ApplicationRecord
  has_one_attached :avatar
  enum :status, %i[pending inactive active]
  validates :name, :subdomain, :status, presence: true
  after_update :logout_users_if_inactive

  def logout_users_if_inactive
    logout_active_users if inactive? || pending?
  end

  def logout_active_users
    active_users = User.where(company_id: id, status: 'active')
    active_users&.each do |user|
      user.update(status: 'inactive')
    end
  end
end
