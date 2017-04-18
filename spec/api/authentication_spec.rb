require "spec_helper"

RSpec.describe "Api Authentication", type: :api do
  describe "Using access token" do
    let!(:alfred) { create(:user) }
    let!(:token) { create(:access_token, user: alfred) }

    it "authenticates via header and query string" do
      get "/v1/user", nil, token_header(alfred)
      expect(http_status).to eq 200
      expect(json_attrs["email"]).to eq alfred.email

      get "/v1/user", access_token: token.token
      expect(http_status).to eq 200
    end
  end

  describe "authenticate_client" do
    let!(:alfred) { create(:user) }
    let!(:client) { create(:client_application) }

    it "responds successfully" do
      post_json "/v1/user/reset_password", email: alfred.email, client_id: client.client_id, client_secret: client.client_secret
      expect(http_status).to eq 200

      post "/v1/user/reset_password", { email: alfred.email }, basic_header(client.client_id, client.client_secret)
      expect(http_status).to eq 200
    end
  end
end
