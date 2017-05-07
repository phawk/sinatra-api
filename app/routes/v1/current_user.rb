module Api
  module Routes
    module V1
      module CurrentUser
        extend Sinatra::Extension
        include Api::Helpers::Routes

        swagger_path "/v1/user" do
          operation :get do
            key :description, "Gets the current user"
            key :tags, ["current user"]
            security do
              key :access_token, []
            end
            response 401 do
              key :description, "Unauthorized"
            end
          end
        end
        get "/v1/user/?" do
          authenticate!
          json current_user
        end

        swagger_path "/v1/user/reset_password" do
          operation :post do
            key :description, "Reset password - sends email"
            key :tags, ["current user"]
            parameter name: :email, type: :string, required: true
            parameter name: :client_id, type: :string, required: true
            parameter name: :client_secret, type: :string, required: true
          end
        end
        post "/v1/user/reset_password" do
          ensure_client_secret!

          User.first(email: params[:email])&.reset_password

          json(data: { message: "Password reset email sent" })
        end

        swagger_path "/v1/user/attributes/password" do
          operation :put do
            key :description, "Reset password - updates password"
            key :tags, ["current user"]
            parameter name: :reset_token, type: :string, required: true
            parameter name: :password, type: :string, required: true
            parameter name: :client_id, type: :string, required: true
            parameter name: :client_secret, type: :string, required: true
            response 404 do
              key :description, "User not found"
            end
            response 400 do
              key :description, "Validation failed"
            end
          end
        end
        put "/v1/user/attributes/password" do
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
end
