class TimePolicy < ApplicationRecord
  acts_as_tenant :company
  belongs_to :employee_group
end
