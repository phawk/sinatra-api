require "bcrypt"

class PasswordVerifier
  def initialize(digest)
    @bcrypt = BCrypt::Password.new(digest)
  rescue BCrypt::Errors::InvalidHash
    @bcrypt = nil
  end

  def verify(plaintext)
    return false unless @bcrypt
    @bcrypt == plaintext
  end
end
