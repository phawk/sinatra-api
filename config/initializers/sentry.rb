Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.environments = %w[staging production]
  config.current_environment = ENV["APP_ENV"]
  config.excluded_exceptions += %w[Sinatra::NotFound ActiveRecord::RecordNotFound]
  config.release = ENV["HEROKU_SLUG_COMMIT"]
end
