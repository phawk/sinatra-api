require 'securerandom'
require 'jwt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :client_applications

  validates_uniqueness_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_presence_of :email, :password
  validates :password, length: { minimum: 8 }, on: :create

  def self.find_by_reset_token(token)
    payload = JWT.decode(token, ENV['JWT_SECRET_KEY'])

    return nil unless Time.now < payload["expires"]

    find(payload["user_id"])
  rescue JWT::DecodeError => e
    nil
  end

  def public_params
    attributes.slice("id", "name", "email", "created_at")
  end

  def display_name
    name || email
  end

  def reset_password
    payload = {
      "user_id" => self.id,
      "expires" => 24.hours.from_now
    }

    jwt_token = JWT.encode(payload, ENV['JWT_SECRET_KEY'], "HS512")

    ::Api::Mailers::User.new.reset_password(self, jwt_token)
  end

  def update_password(password)
    if password.length < 8
      self.errors.add(:password, "Your password is too short")
      return false
    end

    self.password = password
    save
  end

  def password
    @password ||= Password.new(password_digest) if password_digest
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

end
