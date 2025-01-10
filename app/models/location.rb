class Location < ApplicationRecord
  acts_as_tenant :company
  has_many :users, dependent: :destroy
  validates :work_location, :country, :city, :state, :zip_code, :address, presence: true
  scope :get_all_locations, ->(current_company_id) { where(company_id: [nil, current_company_id]) }
end
