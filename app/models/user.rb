require "password_hasher"

class User < Sequel::Model
  attr_reader :password

  searchable_columns :name, :email

  one_to_many :client_applications
  one_to_many :access_tokens

  def display_name
    name || email
  end

  def update_password(password)
    self.password = password
    save
  end

  def password=(plaintext)
    @password = plaintext
    self.password_digest = PasswordHasher.new.hash_plaintext(plaintext)
  end

  def email=(email)
    super(email.try(:downcase))
  end
end
