module Api
  module Mailers
    class User < BaseMailer

      def reset_password(user, jwt_token)
        @user = user
        @jwt_token = jwt_token

        send to: user.email, subject: "Password reset instructions"
      end

    end
  end
end
