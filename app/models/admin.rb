# app/models/admin.rb
# frozen_string_literal: true

# admin's model
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add attribute, (options[:message] || 'is not an email')
    end
  end
end

class Admin < ApplicationRecord
  validates :user_email, presence: { message: 'must be given please' }, email: true
  validates :user_email, presence: true, uniqueness: true
  validates :joining_date, presence: true

  acts_as_tenant :company

  def self.sheet_date(date)
    date.at_beginning_of_week.strftime('%d:%m:%Y')..date.at_end_of_week.strftime('%d:%m:%Y')
  end
end
