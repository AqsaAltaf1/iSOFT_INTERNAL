# frozen_string_literal: true

class Attachment < ApplicationRecord
  include AttachmentScopes
  acts_as_tenant :company
  belongs_to :attachable, polymorphic: true
  has_many_attached :files, dependent: :destroy
  validates :files, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'application/pdf', 'application/zip', 'application/vnd.ms-excel',
                                                           'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                           'application/msword', 'application/xlsx',
                                                           'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                                           'text/plain', 'application/x-ole-storage', 'video/mp4', 'audio/mp3', 'audio/mpeg'], size_range: 1..5.megabytes }
  scope :by_attachment_type, ->(attachment_type) { where(attachment_type:).order(created_at: :desc) }
  def self.folder_view(zip)
    Cloudinary::Utils.private_download_url("#{zip.key}.#{zip.filename.to_s.partition('.').last}", 'zip',
                                           resource_type: :raw)
  end
end
