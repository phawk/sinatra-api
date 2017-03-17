module Api
  class Base
    namespace '/v1/user' do

      swagger_path '/v1/user' do
        operation :get do
          key :description, 'Gets the current user'
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
          key :description, 'Reset password - sends email'
          parameter { key :name, :email }
        end
      end
      post '/reset_password' do
        ensure_client_secret!

        user = User.find_by(email: params[:email])

        unless user.nil?
          user.reset_password
        end

        json({ message: "Password reset email sent" })
      end

      swagger_path '/v1/user/attributes/password' do
        operation :put do
          key :description, 'Reset password - updates password'
          parameter { key :name, :reset_token }
          parameter { key :name, :password }
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
        halt_with_404_not_found("No user found for reset token") if user.nil?

        if user.update_password(params[:password])
          json({ message: "Password has been reset" })
        else
          halt 400, json({ message: "Validation failed", errors: user.errors.full_messages })
        end
      end

    end
  end
end
