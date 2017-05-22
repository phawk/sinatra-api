require "bcrypt"

class PasswordHasher
  def hash_plaintext(plaintext)
    BCrypt::Password.create(plaintext)
  end
end
