source 'https://rubygems.org'

ruby '2.3.1'

gem 'activesupport', require: 'active_support/core_ext/hash'

# Sinatra microframework
gem 'rack', '>= 2.0'
gem 'rack-contrib'
gem 'rake'
gem 'sinatra', '>= 2.0.0.rc1'
gem 'sinatra-activerecord', '~> 2.0.12'
gem 'sinatra-contrib', '>= 2.0.0.rc1'

# Load enviornment variables
gem 'dotenv'

# Serve with puma
gem 'puma'

# DB
gem 'pg'
gem 'activerecord', '~> 5.0'

# JSON serialization
gem 'active_model_serializers', '~> 0.10.0'

# Use warden for authentication
gem 'warden'

# Sending emails
gem 'mail'
gem 'postmark'

# Useful libs
gem 'multi_json'
gem 'jwt'
gem 'bcrypt'
gem 'rack-cors', require: 'rack/cors'

# API Docs
gem 'swagger-blocks'

group :development do
  gem 'shotgun'
end

group :development, :test do
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

  # Factories
  gem 'factory_girl'
  gem 'faker', '~> 1.2.0'
end
