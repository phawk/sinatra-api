class UserSerializer < Blueprinter::Base
  identifier :id

  fields :name, :email, :last_login, :created_at, :updated_at
end
