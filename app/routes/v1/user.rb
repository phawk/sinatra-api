module Api
  class Base
    namespace '/v1/user' do

      swagger_path '/v1/user' do
        operation :get do
          key :title, 'Get current user'
          key :description, 'Fetches the current user by their access token'
          key :tags, ["Current User"]
          security do
            key :access_token, []
          end
          response 401 do
            key :description, 'Unauthorized'
          end
        end
      end
      get '/?' do
        authenticate!
        json current_user
      end

      swagger_path '/v1/user/reset_password' do
        operation :post do
          key :title, 'Request password reset'
          key :description, 'Sends an email to the user with a reset token to update their password'
          key :tags, ["Current User"]
          parameter name: :email, type: :string, required: true
          parameter name: :client_id, type: :string, required: true
          parameter name: :client_secret, type: :string, required: true
        end
      end
      post '/reset_password' do
        ensure_client_secret!

        user = User.find(email: params[:email])

        unless user.nil?
          user.reset_password
        end

        json(data: { message: "Password reset email sent" })
      end

      swagger_path '/v1/user/attributes/password' do
        operation :put do
          key :title, 'Reset password'
          key :description, 'Resets the users password using a reset token'
          key :tags, ["Current User"]
          parameter name: :reset_token, type: :string, required: true
          parameter name: :password, type: :string, required: true
          parameter name: :client_id, type: :string, required: true
          parameter name: :client_secret, type: :string, required: true
          response 404 do
            key :description, 'User not found'
          end
          response 400 do
            key :description, 'Validation failed'
          end
        end
      end
      put '/attributes/password' do
        ensure_client_secret!

        user = User.find_by_token(params[:reset_token])
        halt_not_found("No user found for reset token") if user.nil?

        if user.update_password(params[:password])
          json(data: { message: "Password has been reset" })
        else
          halt_unprocessible_entity(user)
        end
      end

    end
  end
end
