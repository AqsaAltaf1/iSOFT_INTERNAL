# frozen_string_literal: true

class Notification < ApplicationRecord
  acts_as_tenant :company
  include Noticed::Model
  belongs_to :recipient, polymorphic: true
end
