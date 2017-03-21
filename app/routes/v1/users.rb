module Api
  class Base
    namespace '/v1/users' do

      swagger_path '/v1/users' do
        operation :post do
          key :description, 'Create user'
          key :tags, %w(users)
          parameter name: :name, type: :string, required: true
          parameter name: :email, type: :string, required: true
          parameter name: :password, type: :string, required: true
          parameter name: :client_id, type: :string, required: true
          parameter name: :client_secret, type: :string, required: true
          response 400 do
            key :description, 'Validation failed'
          end
        end
      end
      post '/?' do
        ensure_client_secret!

        user = User.new(params.slice(:name, :email, :password))

        unless user.save
          halt_with_422_unprocessible_entity(user)
        end

        json user
      end

    end
  end
end
