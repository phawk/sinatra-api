require "signin_token"

class DeliverPasswordResetToken
  def call(email)
    user = User.first(email: email)

    if user
      signin_token = SigninToken.new.create(user_id: user.id, exp: 24.hours.from_now.to_i)
      Api::Mailers::User.new.reset_password(user, signin_token)
    end
  end
end
