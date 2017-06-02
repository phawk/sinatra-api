require "spec_helper"

RSpec.describe "Api Authentication", type: :api do
  describe "Using valid JWT" do
    it "authenticates via header and query string" do
      get "/private"
      expect(http_status).to eq(401)

      get "/private", nil, token_header(1)
      expect(http_status).to eq(200)
      expect(response_json["private"]).to eq("things")

      get "/private", access_token: build_jwt(user_id: 1)
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
