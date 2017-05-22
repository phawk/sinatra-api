class ClientApplication < Sequel::Model
  many_to_one :user
  one_to_many :access_tokens

  def before_create
    generate_tokens
    super
  end

  def authorize(secret)
    client_secret == secret
  end

  def elevated_privileges?
    in_house_app?
  end

  def generate_tokens
    self.client_id = SecureRandom.hex(32)
    self.client_secret = SecureRandom.hex(32)
  end
end
