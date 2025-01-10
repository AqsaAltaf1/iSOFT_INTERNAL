class GroupMember < ApplicationRecord
  acts_as_tenant :company
  belongs_to :employee_group, dependent: :destroy
  # serialize :location, Array
  # serialize :department, Array
  # serialize :designation, Array
  # serialize :employment_type, Array
   
end
