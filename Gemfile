source 'http://rubygems.org'

ruby '2.1.0'

gem 'activesupport', require: 'active_support/core_ext/hash'

# Sinatra microframework
gem 'rack'
gem 'rake'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-contrib'

# Serve with unicorn
gem 'unicorn'

# DB
gem 'pg'
gem 'activerecord'
gem 'sinatra-activerecord'

# Use warden for authentication
gem 'warden'

# Sending emails
gem 'mail'
gem 'postmark'

group :development, :test do
  gem 'dotenv'
  gem 'minitest'
  gem 'minitest-rg'
end

group :test do
  gem 'rack-test', '~> 0.6.1'
  gem 'mocha', '~> 1.1', require: false

  # Factories
  gem 'factory_girl'
  gem 'faker', '~> 1.2.0'
end

# Useful libs
gem 'multi_json'
gem 'jwt'
gem 'bcrypt'
