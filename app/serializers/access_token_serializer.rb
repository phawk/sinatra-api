class AccessTokenSerializer < ApplicationSerializer
  attributes :id, :access_token, :client,
             :created_at, :updated_at

  def client
    object.client_application.name
  end
end
