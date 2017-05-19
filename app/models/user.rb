require "active_support/core_ext/integer/time"
require "securerandom"
require "jwt"

class User < Sequel::Model
  attr_reader :password

  include BCrypt

  searchable_columns :name, :email

  one_to_many :client_applications
  one_to_many :access_tokens

  def self.find_by_token(token)
    payload = JWT.decode(token, ENV["JWT_SECRET_KEY"])[0]

    return nil unless Time.now < Time.parse(payload["expires"])

    find(id: payload["user_id"])
  rescue JWT::DecodeError
    nil
  end

  def self.find_by_token!(token)
    find_by_token(token) || raise(ActiveRecord::RecordNotFound)
  end

  def display_name
    name || email
  end

  def signin_token(expires: 24.hours.from_now)
    payload = {
      "user_id" => id,
      "expires" => expires
    }

    JWT.encode(payload, ENV["JWT_SECRET_KEY"], "HS512")
  end

  def reset_password
    ::Api::Mailers::User.new.reset_password(self, signin_token)
  end

  def update_password(password)
    self.password = password
    save
  end

  def authenticate(password)
    return false unless password_digest
    digest = Password.new(password_digest)
    digest == password
  end

  def password=(new_password)
    @password = new_password
    self.password_digest = Password.create(new_password) if new_password
  end

  def email=(email)
    super(email.try(:downcase))
  end
end
