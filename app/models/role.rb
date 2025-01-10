# frozen_string_literal: true

class Role < ApplicationRecord
  # acts_as_tenant :company
  has_many :users, dependent: :destroy
  validates :name, presence: true
  scope :get_all_roles, ->(current_company_id) { where(company_id: [nil, current_company_id]) }
  attr_accessor :permission_ids_input

  has_and_belongs_to_many :permissions, join_table: 'roles_permissions'
  before_validation :assign_permissions_from_input, on: [:create, :update]
  before_validation :normalize_name
  validate :at_least_one_permission

  private

  def assign_permissions_from_input
    self.permission_ids = permission_ids_input&.reject(&:blank?) if permission_ids_input.present?
  end

  def at_least_one_permission
    errors.add(:base, 'At least one permission is required') if permissions.empty?
  end

  def normalize_name
    self.name = normalize_string(name)
  end

  def normalize_string(str)
    str.downcase.gsub(/[^a-z0-9]/, '_')
  end
end
