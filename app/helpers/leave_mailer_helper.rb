# frozen_string_literal: true

module LeaveMailerHelper
  def get_base_url
    if Rails.env.production?
      'https://isoft-internal-staging.herokuapp.com'
    else
      'http://127.0.0.1:3000'
    end
  end
end
