class ClientApplicationSerializer < ApplicationSerializer
  attributes :id, :name, :client_id,
             :created_at, :updated_at

  belongs_to :user
end
