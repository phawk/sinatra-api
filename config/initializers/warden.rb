require "signin_token"
require "ostruct"

Warden::Manager.before_failure do |env,opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  env["REQUEST_METHOD"] = "POST"
end

Warden::Manager.after_authentication do |user,auth,opts|
  user.update(last_login: Time.now)
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

    if (user = User.find_by_token(token_str))
      success!(user)
    else
      fail!("Could not log in")
    end
  rescue SigninToken::ParseError => e
    throw(:warden, message: "Auth token error: #{e.message}")
  end

  def store?
    false
  end
end
