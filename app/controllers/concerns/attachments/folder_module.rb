# frozen_string_literal: true

# concerns/attachments/folder_module.rb
module Attachments
  module FolderModule
    include ActiveSupport::Concern

    def folder_view_data
      @attached = Attachment.find(params[:attachment_id])
      @files = @attached.files.where(id: params[:file_id])
      @attachment_name = @files.first.blob.filename
      @zip = @files.first.blob
      @owner_name = User.get_attachment_owner_name(params[:attachment_id])
    end

    def zip_temp_file(zipfile)
      zipfile.binmode # This might not be necessary depending on the zip file
      zipfile.write(HTTParty.get(Attachment.folder_view(@zip)).body)
      zipfile.close
    end

    def zipfile_part(zipfile)
      @file_name = []
      Zip::File.open(zipfile.path) do |file|
        file.each do |content|
          @file_name << content
        end
      end
    end
  end
end
