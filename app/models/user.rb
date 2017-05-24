require "app/models/signin_token"

class User < Sequel::Model
  attr_reader :password

  include BCrypt

  searchable_columns :name, :email
  sortable_columns :name, :email, :created_at, :updated_at

  one_to_many :client_applications
  one_to_many :access_tokens

  def display_name
    name || email
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
