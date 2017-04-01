require 'securerandom'
require 'jwt'

class User < Sequel::Model
  attr_accessor :password_changing

  include BCrypt

  one_to_many :client_applications
  one_to_many :access_tokens

  def validate
    super
    validates_presence :email
    validates_unique :email
    validates_format /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :email, message: 'is not a valid email address'
    validates_presence :password if new? || password_changing
    validates_min_length 8, :password if new? || password_changing
  end

  def self.find_by_token(token)
    payload = JWT.decode(token, ENV['JWT_SECRET_KEY'])[0]

    return nil unless Time.now < Time.parse(payload["expires"])

    find(id: payload["user_id"])
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
    self.password_changing = true
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

  def email=(email)
    super(email.try(:downcase))
  end
end
