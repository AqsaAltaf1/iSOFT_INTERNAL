# frozen_string_literal: true

module CompaniesHelper
  def company_image(company)
    cl_image_tag(company.avatar.key, format: 'jpg', height: '50', width: '190')
  end
end
