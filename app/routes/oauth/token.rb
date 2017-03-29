module Api
  class Base
    namespace '/oauth' do

      swagger_path '/oauth/token' do
        operation :post do
          key :description, 'Returns an access token'
          key :tags, %w(oauth)
          parameter name: :username, type: :string, required: true
          parameter name: :password, type: :string, required: true
          parameter name: :client_id, type: :string, required: true
          parameter name: :client_secret, type: :string, required: true
          response 401 do
            key :description, 'Unauthorized'
          end
        end
      end
      post '/token' do
        ensure_client_secret!

        username = params[:username] || params[:email]

        user = User.find(email: username)

        if user && user.authenticate(params[:password])
          token = AccessToken.for_client(current_client)
          token.user = user

          json token.save
        else
          halt_authorization_required("Authentication failed for: #{username}")
        end
      end

    end
  end
end
