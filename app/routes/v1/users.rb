module Api
  class Base
    namespace '/v1/users' do

      # new user signup
      post '/?' do
        ensure_client_secret!

        user = User.new(params.slice(:name, :email, :password))

        unless user.save
          halt 400, json({ message: "Validation failed", errors: user.errors.full_messages })
        end

        json user
      end

    end
  end
end
