module Api
  class Base
    namespace '/oauth' do

      post '/token' do
        ensure_client_secret!

        username = parsed_params[:username] || parsed_params[:email]

        user = User.find_by(email: username)

        if user && user.password == parsed_params[:password]
          token = AccessToken.for_client(current_client)
          token.user = user
          token.save

          json token.public_params
        else
          halt_with_401_authorization_required("Authentication failed for: #{username}")
          # halt 401, json({ error: "Authentication failed for: #{username}" })
        end
      end

    end
  end
end
