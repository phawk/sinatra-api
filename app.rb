require_relative './config/boot'
require 'token_failure_app'
require 'json'

module Api
  class Application < ::Sinatra::Base
    # JSON 404's
    error Sinatra::NotFound do
      content_type :json
      halt 404, JSON.dump({
        error_code: "not_found",
        message: "Endpoint '#{request.path_info}' not found"
      })
    end

    use Api::Routes::Main
    use Api::Routes::OAuth::Token
    use Api::Routes::V1::User
    use Api::Routes::V1::Users
  end
end
