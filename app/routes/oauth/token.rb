module Api
  class Base
    namespace '/oauth' do

      swagger_path '/oauth/token' do
        operation :post do
          key :description, 'Returns an access token'
          parameter { key :name, :username }
          parameter { key :name, :password }
          response 401 do
            key :description, 'Unauthorized'
          end
        end
      end
      post '/token' do
        ensure_client_secret!

        username = params[:username] || params[:email]

        user = User.find_by(email: username)

        if user && user.password == params[:password]
          token = AccessToken.for_client(current_client)
          token.user = user
          token.save

          json token
        else
          halt_with_401_authorization_required("Authentication failed for: #{username}")
          # halt 401, json({ error: "Authentication failed for: #{username}" })
        end
      end

    end
  end
end
