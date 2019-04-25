require "spec_helper"

RSpec.describe "Api Authentication", type: :api do
  describe "Obtaining a JWT" do
    context "when credentials are valid" do
      it "returns a JWT and user info" do
        user = User.first

        post "/auth/sign_in", {
          email: "pete@phawk.co.uk",
          password: "hunter2"
        }

        expect(http_status).to eq(200)

        expect(json[:data][:email]).to eq("pete@phawk.co.uk")
        expect(json[:meta][:access_token]).not_to be_nil
      end
    end

    context "when credentials are incorrect" do
      it "returns unauthorized" do
        post "/auth/sign_in", {
          email: "bad@email.com",
          password: "badpassword"
        }

        expect(http_status).to eq(401)
        expect(json[:error]).to eq("authentication_failed")
      end
    end
  end

  describe "Using valid JWT" do
    it "authenticates via header and query string" do
      user = User.first

      get "/private"
      expect(http_status).to eq(401)

      get "/private", nil, token_header(user.id)
      expect(http_status).to eq(200)
      expect(json["private"]).to eq("things")

      get "/private", access_token: build_jwt(user_id: user.id)
      expect(http_status).to eq(200)
    end
  end

  context "Using expired JWT" do
    it "returns unauthorized" do
      token = build_jwt(user_id: 1, exp: Time.now.to_i - 100)
      get "/private", nil, "HTTP_AUTHORIZATION" => "Bearer #{token}"
      expect(http_status).to eq(401)
    end
  end
end
