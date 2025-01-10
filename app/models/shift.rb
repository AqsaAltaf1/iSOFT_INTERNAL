class Shift < ApplicationRecord
  serialize :working_days, Array
  acts_as_tenant :company
  has_many :users, dependent: :destroy
  validates :name, :working_hours, :start_time, :end_time, presence: true
  scope :get_all_shifts, ->(current_company_id) { where(company_id: [nil, current_company_id]) }
end
