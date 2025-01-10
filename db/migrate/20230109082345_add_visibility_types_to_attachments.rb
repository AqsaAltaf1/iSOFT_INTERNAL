# frozen_string_literal: true

class AddVisibilityTypesToAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :visibility, :boolean, default: true
  end
end
