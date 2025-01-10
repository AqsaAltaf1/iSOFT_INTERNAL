Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] }
  Sidekiq::Scheduler.dynamic = true
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq.yml', __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
end
  
Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'],
  protocol: 2 }
end