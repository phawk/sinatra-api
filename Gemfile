source 'https://rubygems.org'

ruby '2.3.1'

# Core framework dependencies
gem 'activesupport', require: 'active_support/core_ext/hash'
gem 'rack', '>= 2.0'
gem 'rack-contrib'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'
gem 'rack-canonical-host'
gem 'rack-ssl'
gem 'rake'
gem 'sinatra', '>= 2.0.0.rc1'
gem 'sinatra-activerecord', '~> 2.0.12'
gem 'sinatra-contrib', '>= 2.0.0.rc1'
gem 'pg'
gem 'activerecord', '~> 5.0'
gem 'redis', '~> 3.3.3'
gem 'redis-namespace'
gem 'sidekiq'
gem 'multi_json'
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
end

group :test do
  gem 'rack-test', '~> 0.6.3'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl'
  gem 'faker', '~> 1.7.3'
end
