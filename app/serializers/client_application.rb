class ClientApplicationSerializer < BaseSerializer
  attributes :id, :name, :client_id,
             :created_at, :updated_at

  has_one :user
end
