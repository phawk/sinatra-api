module Api
  module Routes
    module V1
      module Users
        extend Sinatra::Extension
        include Api::Helpers::Routes

        swagger_path "/v1/users" do
          operation :post do
            key :description, "Create user"
            key :tags, %w[users]
            parameter name: :name, type: :string, required: true
            parameter name: :email, type: :string, required: true
            parameter name: :password, type: :string, required: true
            parameter name: :client_id, type: :string, required: true
            parameter name: :client_secret, type: :string, required: true
            response 400 do
              key :description, "Validation failed"
            end
          end
        end
        post "/v1/users/?" do
          ensure_client_secret!

          user = User.new(params.slice(:name, :email, :password))
          user.save

          token = AccessToken.for_client(current_client)
          token.user = user
          token.save

          json(user, meta: { access_token: token.token })
        end
      end
    end
  end
end
