class ClientApplication < ActiveRecord::Base
  belongs_to :user
  has_many :access_tokens

  validates_uniqueness_of :client_id, on: :create
  validates_presence_of :name, :user_id

  before_create :generate_tokens

  def authorize(secret)
    self.client_secret == secret
  end

  def public_params
    attributes.slice(:id, :name, :client_id, :created_at).merge(user: self.user.public_params)
  end

private

  def generate_tokens
    self.client_id = SecureRandom.hex(32)
    self.client_secret = SecureRandom.hex(32)
  end

end
