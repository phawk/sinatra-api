require "base64"
require "signin_token"
require "ostruct"

Warden::Manager.before_failure do |env,opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  env["REQUEST_METHOD"] = "POST"
end

Warden::Strategies.add(:jwt) do
  def valid?
    env["HTTP_AUTHORIZATION"] || params["access_token"]
  end

  def authenticate!
    token_str = params["access_token"]

    if env["HTTP_AUTHORIZATION"]
      token_str = env["HTTP_AUTHORIZATION"].sub(/^Bearer/, "").strip
    end

    payload = SigninToken.new.parse(token_str)
    success!(OpenStruct.new(payload))
  rescue SigninToken::ParseError => e
    throw(:warden, message: "Auth token error: #{e.message}")
  end
end
