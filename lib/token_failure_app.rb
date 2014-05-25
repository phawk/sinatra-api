require 'sinatra/base'

class TokenFailureApp < ::Sinatra::Base
  post '/unauthenticated' do
    status 401
    content_type :json
    message = request.env['warden.options'][:message] || request.env['warden.api.error'] || "Your credentials are invalid"
    MultiJson.dump({ error: "authentication_failed", message: message }, pretty: true)
  end
end
