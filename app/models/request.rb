class Request < ApplicationRecord
  acts_as_tenant :company
  belongs_to :user
  enum :status, %i[pending approved rejected]
  scope :selected_requests, ->(status) { where(status:) }
  has_noticed_notifications model_name: 'Notification'
  scope :selected_type, ->(type) { where(request_type: type) }
  validate :date_from_in_details
  validate :date_to_in_details
  has_many :notes, as: :notable, dependent: :destroy
  has_one_attached :attachment
  def date_from_in_details
    details_date_from = details.try(:[], 'date_from')
    details_date_to = details.try(:[], 'date_to')

    if details_date_from.present? && Date.parse(details_date_from) >= Date.parse(details_date_to)
      errors.add(:details, "date_from less than date_to")
    end
  end

  def date_to_in_details
    details_date_to = details.try(:[], 'date_to')
    details_date_from = details.try(:[], 'date_from')

    if details_date_to.present? && Date.parse(details_date_to) <= Date.parse(details_date_from)
      errors.add(:details, "date_to greater than date_from")
    end
  end
  
end
