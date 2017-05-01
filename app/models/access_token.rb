require 'securerandom'

class AccessToken < Sequel::Model
  many_to_one :user
  many_to_one :client_application

  def validate
    super
    validates_presence %i[client_application_id user_id]
    validates_unique :token
  end

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
