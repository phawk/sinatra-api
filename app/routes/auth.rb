module Api
  module Routes
    class Auth < Base
      post "/sign_in" do
        username = params[:username] || params[:email]

        user = User.find_by(email: username)

        if user&.authenticate(params[:password])
          json(user, meta: { access_token: user.signin_token(expires: nil) })
        else
          halt_authorization_required("Authentication failed for: #{username}")
        end
      end
    end
  end
end
