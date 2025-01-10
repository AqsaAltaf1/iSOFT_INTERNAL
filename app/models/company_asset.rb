# frozen_string_literal: true

class CompanyAsset < ApplicationRecord
  acts_as_paranoid
  acts_as_tenant :company
  belongs_to :user, optional: true
  has_many :histories, dependent: :destroy
  has_many :users, through: :histories
  validates :name, presence: true
  validates :unique_identifier, presence: true, uniqueness: true
  has_many_attached :images
  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validate :validate_max_number_of_images

  # validate :return_date_cannot_be_less_than_or_equal_to_given_date
  # before_update :create_history

  has_rich_text :description
  enum :status, %i[in_stock assigned broken sold_out available]

  def self.all_statuses
    statuses.keys.map { |key| [key.titleize, key] }
  end

  def validate_max_number_of_images
    errors.add(:base, 'You can only upload a maximum of 4 images.') if images.count > 4
  end

  def return_date_cannot_be_less_than_or_equal_to_given_date
    if return_date.present? && given_date.present? && return_date <= given_date
      errors.add(:return_date,
                 'cannot be less than or equal to given date')
    end
  end

  def user_present?
    user.present?
  end

  def create_history
    company_asset = CompanyAsset.find_by(id:)
    if user_id_changed? && company_asset.user_id.present?
      histories.create(user_id: company_asset.user_id, company_asset_id: company_asset.id,
                       given_date: company_asset.given_date,
                       return_date: company_asset.return_date.present? ? company_asset.return_date : Date.today)
    end
  end

  def user_changed
    user_id_changed? && CompanyAsset.find_by(id:).user_id.present?
  end
end
