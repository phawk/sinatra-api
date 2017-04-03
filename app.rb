require_relative './config/boot'
require 'token_failure_app'

module Api
  class Base < ::Sinatra::Base
    register ::Sinatra::Namespace
    use Rack::PostBodyContentTypeParser
    include Swagger::Blocks

    helpers ::Api::Helpers::ErrorHandling
    helpers ::Api::Helpers::Auth
    helpers ::Api::Helpers::Json

    set :app_file, __FILE__

    configure do
      enable :raise_errors
      disable :dump_errors, :show_exceptions
      use Rack::CommonLogger, $logger

      before { content_type(:json) }

      use Warden::Manager do |manager|
        manager.default_strategies :access_token
        manager.failure_app = ::TokenFailureApp # lib/token_failure_app.rb
      end
    end

    configure :test do
      enable :raise_errors
    end
  end
end

# Autoload all routes
Dir['./app/routes/**/*.rb'].sort.uniq.each { |rb| require rb }