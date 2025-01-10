# frozen_string_literal: true

class UserProject < ApplicationRecord
  acts_as_tenant :company
  belongs_to :user
  belongs_to :project
end
