require 'securerandom'

class AccessToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :client_application

  validates_uniqueness_of :token, on: :create
  validates_presence_of :client_application_id, :user_id

  before_create :generate_token

  def self.for_client(client)
    token = new
    token.client_application = client
    token
  end

private

  def generate_token
    self.token = SecureRandom.hex(32)
  end

end
