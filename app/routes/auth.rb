module Api
  module Routes
    class Auth < Base
      swagger_path "/auth/sign_in" do
        operation :post do
          key :description, "Returns an access token and the current user"
          key :tags, %w[auth]
          parameter name: :username, in: :formData, type: :string, required: true
          parameter name: :password, in: :formData, type: :string, required: true
          response(401) { key :description, "Unauthorized" }
        end
      end
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
