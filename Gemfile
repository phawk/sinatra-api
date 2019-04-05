source 'https://rubygems.org'

ruby '2.6.0'

# Core framework dependencies
gem 'activesupport', require: 'active_support'
gem 'rack', '>= 2.0'
gem 'rack-contrib'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'
gem 'rack-canonical-host'
gem 'rack-ssl'
gem 'rack-health'
gem 'rack-cloudflare_ip'
gem 'rake'
gem 'sinatra', '>= 2.0.2', require: 'sinatra/base'
gem 'sinatra-contrib', '>= 2.0.2'
gem 'pg', '~> 0.20.0'
gem 'sinatra-activerecord'
gem 'redis', '~> 3.3.3'
gem 'redis-namespace'
gem 'sidekiq'
gem 'puma' # app server
gem 'warden' # authentication
gem 'mail'
gem 'postmark'
gem 'jwt'
gem 'swagger-blocks' # API Docs
gem 'jsonapi-serializers'
gem 'dry-validation'

# Extra dependencies
gem 'http'
gem 'sentry-raven'

# Development and test dependencies
group :development do
  gem 'shotgun' # dev server
  gem 'letter_opener'
end

group :development, :test do
  gem 'dotenv'
  gem 'rspec'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier', '~> 1.7.1'
  gem 'terminal-notifier-guard', '~> 1.7.0'
  gem 'rubocop', require: false
  gem 'bundler-audit', require: false
end

group :test do
  gem 'rack-test', '~> 0.6.3'
  gem 'factory_girl'
  gem 'faker', '~> 1.7.3'
end
