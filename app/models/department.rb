class Department < ApplicationRecord
    acts_as_tenant :company
    has_many :users, dependent: :destroy
    validates :name, presence: true
    scope :get_all_departments, ->(current_company_id) { where(company_id: [nil, current_company_id]) }
end
