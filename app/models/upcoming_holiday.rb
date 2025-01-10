# frozen_string_literal: true

class UpcomingHoliday < ApplicationRecord
  acts_as_tenant :company
  validates :title, :description, :date, presence: true
  validate :date_must_be_in_the_future

  def date_must_be_in_the_future
    errors.add(:date, 'of holiday must be in future.') if date.present? && date <= Date.today
  end
end
