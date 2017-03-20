require 'securerandom'
require 'jwt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :client_applications
  has_many :access_tokens

  validates :email, email: true, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  def self.find_by_token(token)
    payload = JWT.decode(token, ENV['JWT_SECRET_KEY'])[0]

    return nil unless Time.now < Time.parse(payload["expires"])

    find(payload["user_id"])
  rescue JWT::DecodeError => e
    nil
  end

  def self.find_by_token!(token)
    find_by_token(token) || fail(ActiveRecord::RecordNotFound)
  end

  def display_name
    name || email
  end

  def signin_token(expires: 24.hours.from_now)
    payload = {
      "user_id" => id,
      "expires" => expires
    }

    JWT.encode(payload, ENV['JWT_SECRET_KEY'], "HS512")
  end

  def reset_password
    ::Api::Mailers::User.new.reset_password(self, signin_token)
  end

  def update_password(password)
    if password.length < 8
      self.errors.add(:password, "Your password is too short")
      return false
    end

    self.password = password
    save
  end

  def authenticate(password)
    return false unless password_digest
    digest = Password.new(password_digest)
    digest == password
  end

  def password
    @password
  end

  def password=(new_password)
    @password = new_password
    self.password_digest = Password.create(new_password) if new_password
  end
end
