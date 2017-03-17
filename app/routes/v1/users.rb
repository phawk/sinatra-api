module Api
  class Base
    namespace '/v1/users' do

      swagger_path '/v1/users' do
        operation :post do
          key :description, 'Create user'
          parameter { key :name, :name }
          parameter { key :name, :email }
          parameter { key :name, :password }
          response 400 do
            key :description, 'Validation failed'
          end
        end
      end
      post '/?' do
        ensure_client_secret!

        user = User.new(params.slice(:name, :email, :password))

        unless user.save
          halt 400, json({ message: "Validation failed", errors: user.errors.full_messages })
        end

        json user
      end

    end
  end
end
