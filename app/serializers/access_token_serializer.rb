class AccessTokenSerializer < BaseSerializer
  attributes :id, :token, :client,
             :created_at, :updated_at

  attribute :client do
    object.client_application.name
  end
end
