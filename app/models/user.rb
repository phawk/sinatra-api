require "password_hasher"
require "password_verifier"
require "signin_token"

class User < ActiveRecord::Base
  def self.find_by_token(token)
    payload = SigninToken.new.parse(token)

    find(payload["user_id"])
  rescue SigninToken::ParseError
    nil
  end

  def self.find_by_token!(token)
    find_by_token(token) || raise(ActiveRecord::RecordNotFound)
  end

  def signin_token(expires: 24.hours.from_now)
    SigninToken.new.create(
      "user_id" => id,
      "expires" => expires
    )
  end

  def password=(plaintext)
    self.password_digest = PasswordHasher.new.hash_plaintext(plaintext)
  end

  def authenticate(plaintext)
    PasswordVerifier.new(password_digest).verify(plaintext)
  end
end
