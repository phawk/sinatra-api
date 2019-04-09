require "jwt"

class SigninToken
  def initialize(secret = ENV["JWT_SECRET_KEY"])
    @secret = secret
  end

  def create(payload)
    JWT.encode(payload, @secret, "HS512")
  end

  def parse(token)
    JWT.decode(token, @secret, true, { algorithm: "HS512" })[0]
  rescue JWT::ExpiredSignature
    raise ParseError.new("Token expired")
  rescue JWT::DecodeError
    raise ParseError.new("Invalid token")
  end

  class ParseError < StandardError; end
end
