module Api
  class Base
    error Sinatra::NotFound do
      halt_not_found("Endpoint '#{request.path_info}' not found")
    end

    error Sequel::ValidationFailed do |e|
      halt_unprocessible_entity(e)
    end
  end
end
