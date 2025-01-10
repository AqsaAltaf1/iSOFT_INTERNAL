# frozen_string_literal: true

module HelpDocumentsHelper
  def help_image_helper(picture)
    link_to picture.blob.filename.to_s, Cloudinary::Utils.private_download_url(picture.key, 'jpg'), attachment: true,
                                                                                                    style: 'color: blue;'
  end

  def help_documents_helper(picture)
    if picture.blob.filename.to_s.include?('pdf')
      link_to picture.blob.filename.to_s, Cloudinary::Utils.private_download_url(picture.key, 'pdf'),
              attachment: true, resource_type: :raw, style: 'color: blue;'
    else
      link_to picture.blob.filename.to_s,
              Cloudinary::Utils.private_download_url("#{picture.key}.#{picture.blob.filename.to_s.partition('.').last}", 'pdf'), attachment: true, resource_type: :raw, style: 'color: blue;'
    end
  end
end
