require "securerandom"

class AccessToken < Sequel::Model
  many_to_one :user
  many_to_one :client_application

  def before_create
    generate_token
    super
  end

  def self.for_client(client)
    token = new
    token.client_application = client
    token
  end

  def generate_token
    self.token = SecureRandom.hex(32)
  end
end
