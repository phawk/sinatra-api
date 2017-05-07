module Api
  module Routes
    module Errors
      extend Sinatra::Extension
      include Api::Helpers::Routes

      error Sinatra::NotFound do
        content_type :json
        halt 404, JSON.dump(
          error_code: "not_found",
          message: "Endpoint '#{request.path_info}' not found"
        )
      end

      error Sequel::ValidationFailed do |e|
        halt_unprocessible_entity(e)
      end
    end
  end
end
