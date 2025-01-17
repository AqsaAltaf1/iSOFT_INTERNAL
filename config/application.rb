# config/application.rb
# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Application Modle
module IsoftInternal
  # class for application module
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.assets.paths << Rails.root.join('app', 'assets', 'imgage')
    config.eager_load_paths += %W[#{config.root}/lib]
    config.autoload_paths << Rails.root.join('lib')
    config.assets.initialize_on_precompile = false
    config.beginning_of_week = :monday
    config.hosts = nil
  end
end
