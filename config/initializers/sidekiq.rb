Sidekiq.configure_server do |config|
  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
end
