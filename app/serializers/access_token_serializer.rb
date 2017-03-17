class AccessTokenSerializer < ApplicationSerializer
  attributes :id, :token, :client,
             :created_at, :updated_at

  def client
    object.client_application.name
  end
end
