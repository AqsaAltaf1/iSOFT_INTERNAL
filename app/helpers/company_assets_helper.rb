# frozen_string_literal: true

module CompanyAssetsHelper
  def company_asset_image(company_asset)
    link_to cl_image_tag(Cloudinary::Utils.private_download_url(company_asset.key, 'jpg'), height: '140'),
            Cloudinary::Utils.private_download_url(company_asset.key, 'jpg'), attachment: true
  end

  def get_status
    CompanyAsset.all_statuses
  end
end
