class EmployeeGroup < ApplicationRecord
  acts_as_tenant :company
  validates :code, :name, :employee, presence: true
  serialize :employee, Array
  has_one :time_policy, dependent: :destroy
  accepts_nested_attributes_for :time_policy, :allow_destroy => true
end
