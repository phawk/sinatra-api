require_relative './lib/rack/cloud_flare_middleware'
require_relative './lib/rack/health_check'
require_relative './lib/exception_handling'
require_relative './app'
require 'sidekiq/web'
require 'rack/ssl'
require 'rack-timeout'

use ExceptionHandling
use Rack::Timeout, service_timeout: 10
use Rack::HealthCheck
use Rack::CloudFlareMiddleware
use Rack::SSL if ENV['RACK_ENV'] == 'production'
use Rack::CanonicalHost, ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']
use Rack::Deflater

use Rack::Cors do
  allow do
    origins ENV.fetch('ALLOWED_CORS_ORIGINS', '*')
    resource '*', headers: :any, methods: :any, max_age: 2_592_000 # 30 days
  end
end

run Rack::URLMap.new('/' => Api::Application, '/sidekiq' => Sidekiq::Web)
