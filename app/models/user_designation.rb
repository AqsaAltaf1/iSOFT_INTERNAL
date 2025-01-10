class UserDesignation < ApplicationRecord
  belongs_to :company
  has_many :users, dependent: :destroy
  validates :name, presence: true
  scope :get_all_designations, ->(current_company_id) { where(company_id: [nil, current_company_id]) }

end
