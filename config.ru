require_relative "./lib/exception_handling"
require_relative "./config/boot"
require "rack/cloudflare_ip"
require "sidekiq/web"
require "rack/ssl"
require "rack-timeout"

STATIC_PATHS ||= %w[/favicon.ico /robots.txt /docs].map(&:freeze)

use Rack::Static, root: File.expand_path(__dir__ + "/public"),
                  urls: STATIC_PATHS,
                  cache_control: "public, max-age=31536000"

use ExceptionHandling
use Rack::Timeout, service_timeout: 10
use Rack::Health, path: "/health"
use Rack::CloudflareIp
use Rack::SSL if ENV["APP_ENV"] == "production"
use Rack::CanonicalHost, ENV["CANONICAL_HOST"] if ENV["CANONICAL_HOST"]
use Rack::Deflater
use Rack::Cors do
  allow do
    origins ENV.fetch("ALLOWED_CORS_ORIGINS", "*")
    resource "*", headers: :any, methods: :any, max_age: 2_592_000 # 30 days
  end
end

map("/sidekiq") { run Sidekiq::Web }
map("/auth") { run Api::Routes::Auth }
map("/private") { run Api::Routes::V1::Private }
map("/") { run Api::Routes::Main }
