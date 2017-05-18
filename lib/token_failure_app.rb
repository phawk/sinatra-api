require "json"
require "sinatra/base"

class TokenFailureApp < ::Sinatra::Base
  post "/unauthenticated" do
    status :unauthorized
    content_type :json
    JSON.dump(error: "authentication_failed", message: error_message)
  end

  def error_message
    if request.env["warden.options"]
      message = request.env["warden.options"][:message]
    end

    message || request.env["warden.api.error"] || "Your credentials are invalid"
  end
end
