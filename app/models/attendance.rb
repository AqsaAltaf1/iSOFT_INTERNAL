class Attendance < ApplicationRecord
  acts_as_tenant :company
  belongs_to :user, foreign_key: 'user_machine_code', primary_key: 'machine_code'
  scope :user_attendance, ->(machine_code, start_date, end_date) {
  where("DATE(check_in) BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day)
    .where(user_machine_code: machine_code)
  }
end
