# frozen_string_literal: true

class History < ApplicationRecord
  acts_as_tenant :company
  belongs_to :company_asset
  belongs_to :user
  has_many :notes, as: :notable, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  validates :given_date, presence: true, on: :create
  validates :return_date, presence: true, on: :update
  has_rich_text :given_condition
  has_rich_text :return_condition
  after_create proc { change_company_asset_status('assigned') }
  after_update proc { change_company_asset_status('available') }

  def change_company_asset_status(status)
    company_asset.update(status:)
  end
end
