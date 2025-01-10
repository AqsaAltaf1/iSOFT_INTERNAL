# frozen_string_literal: true

class HelpDocument < ApplicationRecord
  acts_as_tenant :company
  has_one_attached :file
  validate :file_content_allowed
  validates :file, presence: true
  validates :name, presence: true

  private

  def file_content_allowed
    allowed_types = ['application/pdf', 'image/jpeg', 'image/png',
                     'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
    max_size_in_bytes = 10.megabytes
    if file.attached? && !file.content_type.in?(allowed_types)
      errors.add(:file, 'is not a valid file type. Allowed types are: PDF, JPEG, PNG, DOCX, XLSX')
    elsif file.blob.byte_size > max_size_in_bytes
      errors.add(:file, 'is too large. Maximum size is 10 MB')
    end
  end
end
