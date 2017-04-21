require "spec_helper"

RSpec.describe Api::Routes::OAuth::Token, type: :api do
  describe "POST /oauth/token" do
    let!(:client_application) { create(:client_application, name: "Tasty Coffee") }
    let!(:user) { create(:user, password: "strongcoffee") }

    before do
      authenticate_client(client_application)
    end

    it "requires valid login details" do
      post "/oauth/token", { email: user.email, password: "milkycoffee" }

      expect(http_status).to eq(401)
      expect(response_json["message"]).to match(/Authentication failed/)
    end

    it "returns an oauth token" do
      post "/oauth/token", { email: user.email, password: "strongcoffee" }

      expect(http_status).to eq(200)
      expect(response_json["access_token"]).to be_a(String)
      expect(response_json["client"]).to eq("Tasty Coffee")
    end
  end
end
