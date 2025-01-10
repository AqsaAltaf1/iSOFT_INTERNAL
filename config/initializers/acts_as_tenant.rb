# frozen_string_literal: true
# # config/initializers/acts_as_tenant.rb

# ActsAsTenant.configure do |config|
#     config.require_tenant = lambda do
#       current_request = Thread.current[:current_request]
#       current_request.present? && ![ "localhost", "127.0.0.1", "lvh.me", "isoftinternal.pagekite.me"].include?(current_request.host)
#     end
# end
