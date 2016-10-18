module Api
  class Base
    namespace '/v1/user' do

      # get the users info
      get '/?' do
        authenticate!
        json(current_user.public_params)
      end

      post '/reset_password' do
        ensure_client_secret!

        user = User.find_by(email: parsed_params[:email])

        unless user.nil?
          user.reset_password
        end

        json({ message: "Password reset email sent" })
      end

      put '/attributes/password' do
        ensure_client_secret!

        user = User.find_by_token(parsed_params[:reset_token])
        halt_with_404_not_found("No user found for reset token") if user.nil?

        if user.update_password(parsed_params[:password])
          json({ message: "Password has been reset" })
        else
          halt 400, json({ message: "Validation failed", errors: user.errors.full_messages })
        end
      end

    end
  end
end
