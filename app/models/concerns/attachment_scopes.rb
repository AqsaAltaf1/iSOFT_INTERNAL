# frozen_string_literal: true

module AttachmentScopes
  extend ActiveSupport::Concern

  included do
    scope :filtered_by_current_user, lambda { |user|
      if user&.user? && !user&.is_hr
        by_attachment_type('company')
      else
        user&.attachments&.by_attachment_type('company')
      end
    }
  end
end
