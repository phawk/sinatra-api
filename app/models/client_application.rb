class ClientApplication < Sequel::Model
  many_to_one :user
  one_to_many :access_tokens

  def validate
    super
    validates_presence [:name, :user_id]
    validates_unique :client_id
  end

  def before_create
    self.generate_tokens
    super
  end

  def authorize(secret)
    self.client_secret == secret
  end

  def has_elevated_privileges?
    in_house_app?
  end

  def generate_tokens
    self.client_id = SecureRandom.hex(32)
    self.client_secret = SecureRandom.hex(32)
  end

end
