source 'https://rubygems.org'

ruby '2.4.0'

# Core framework dependencies
gem 'activesupport', require: 'active_support'
gem 'rack', '>= 2.0'
gem 'rack-contrib'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'
gem 'rack-canonical-host'
gem 'rack-ssl'
gem 'rake'
gem 'sinatra', '>= 2.0.0.rc2', require: 'sinatra/base'
gem 'sinatra-contrib', '>= 2.0.0.rc2'
gem 'pg'
gem 'sequel', '~> 4.44.0'
gem 'redis', '~> 3.3.3'
gem 'redis-namespace'
gem 'sidekiq'
gem 'puma' # app server
gem 'bcrypt'
gem 'warden' # authentication
gem 'mail'
gem 'postmark'
gem 'jwt'
gem 'swagger-blocks' # API Docs
gem 'jsonapi-serializers'

# Extra dependencies
gem 'http'
gem 'sentry-raven'

# Development and test dependencies
group :development do
  gem 'shotgun' # dev server
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
