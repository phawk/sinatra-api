require 'token_failure_app'

module Api
  module Routes
    class Base < ::Sinatra::Base
      register ::Sinatra::Namespace
      use Rack::PostBodyContentTypeParser
      include Swagger::Blocks

      helpers ::Api::Helpers::Errors
      helpers ::Api::Helpers::Auth
      helpers ::Api::Helpers::Json

      set :root, File.expand_path('../../../', __FILE__)

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

      error Sequel::ValidationFailed do |e|
        halt_unprocessible_entity(e)
      end
    end
  end
end
