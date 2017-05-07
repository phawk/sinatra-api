require_relative "./config/boot"
require "token_failure_app"

module Api
  class Application < ::Sinatra::Base
    use Rack::PostBodyContentTypeParser

    helpers ::Api::Helpers::Errors
    helpers ::Api::Helpers::Auth
    helpers ::Api::Helpers::Json

    set :app_file, __FILE__

    configure do
      enable :raise_errors
      disable :dump_errors, :show_exceptions

      before { content_type(:json) }

      use Rack::CommonLogger, $logger

      use Warden::Manager do |manager|
        manager.default_strategies :access_token
        manager.failure_app = ::TokenFailureApp # lib/token_failure_app.rb
      end
    end

    register Api::Routes::Errors
    register Api::Routes::Main
    register Api::Routes::OAuth::Token
    register Api::Routes::V1::CurrentUser
    register Api::Routes::V1::Users
  end
end
