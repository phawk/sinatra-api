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
gem 'activerecord', '~> 5.2.0'
gem 'redis', '~> 3.3.3'
gem 'redis-namespace'
gem 'sidekiq'
gem 'iodine' # app server
gem 'warden' # authentication
gem 'bcrypt'
gem 'mail'
gem 'postmark'
gem 'jwt'
gem 'swagger-blocks', '= 2.0.0' # API Docs
gem 'blueprinter'
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
  gem 'rubocop', require: false
  gem 'bundler-audit', require: false
end

group :test do
  gem 'rack-test', '~> 0.6.3'
  gem 'shoulda-matchers'
end
