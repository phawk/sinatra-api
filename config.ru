require_relative './lib/rack/cloud_flare_middleware'
require_relative './app'
require 'sidekiq/web'
require 'rack/ssl'
require 'rack-timeout'

use Rack::Timeout, service_timeout: 10
use Rack::SSL if ENV['RACK_ENV'] == 'production'
use Rack::CloudFlareMiddleware
use Rack::CanonicalHost, ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any, max_age: 2592000 # 30 days
  end
end

run Rack::URLMap.new('/' => Api::Base, '/sidekiq' => Sidekiq::Web)
