require "token_failure_app"
require "signin_token"

module Api
  module Routes
    class Base < ::Sinatra::Base
      use Rack::PostBodyContentTypeParser
      include Swagger::Blocks

      helpers ::Api::Helpers::Errors
      helpers ::Api::Helpers::Auth
      helpers ::Api::Helpers::Json

      set :root, File.expand_path("../../../", __FILE__)

      configure do
        enable :raise_errors
        disable :dump_errors, :show_exceptions, :logging, :static

        before { content_type(:json) }

        use Warden::Manager do |manager|
          manager.default_strategies :jwt
          manager.failure_app = ::TokenFailureApp # lib/token_failure_app.rb
        end
      end

      error Sequel::Plugins::SortableByColumn::BadRequest do |e|
        halt_bad_request(e.message)
      end

      error Sinatra::NotFound, Sequel::NoMatchingRow do
        halt_not_found("Endpoint '#{request.path_info}' not found")
      end

      error Sequel::ValidationFailed do |e|
        halt_unprocessible_entity(e)
      end

      error SigninToken::ParseError do |e|
        halt_bad_request(e.message)
      end

      def validate!(schema)
        validator = schema.call(params)

        halt_unprocessible_entity(validator) if validator.failure?

        validator.to_h
      end
    end
  end
end
