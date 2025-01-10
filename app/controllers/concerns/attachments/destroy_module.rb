# frozen_string_literal: true

# concerns/attachments/destroy_module.rb
module Attachments
  module DestroyModule
    include ActiveSupport::Concern

    def unless_part
      respond_to do |format|
        @attachments = current_user.attachments
        flash.now[:alert] = 'Please select attachments before deleting'
        format.html { render :index }
      end
    end

    def unless_else_part
      @attachments.each do |attachment|
        @selected_files = attachment.files.where(id: params[:files_ids])
        @selected_files.each do |files|
          Cloudinary::Api.delete_resources(files.key, type: :private)
          files.destroy
        end
      end
    end
  end
end
