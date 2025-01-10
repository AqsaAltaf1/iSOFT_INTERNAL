# frozen_string_literal: true

class AddAttachmentTypeToAcctachments < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :attachment_type, :string
  end
end
