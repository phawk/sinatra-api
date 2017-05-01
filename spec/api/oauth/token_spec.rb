require "spec_helper"

RSpec.describe Api::Routes::OAuth::Token, type: :api do
  describe "POST /oauth/token" do
    let(:client_application) { build_stubbed(:client_application, name: "Tasty Coffee") }

    it "requires valid login details" do
      user = create(:user, password: "strongcoffee")

      authenticate_client(client_application)
      post "/oauth/token", { email: user.email, password: "milkycoffee" }
      expect(http_status).to eq(401)
      expect(response_json["message"]).to match(/Authentication failed/)

      authenticate_client(client_application)
      post "/oauth/token", { email: user.email, password: "strongcoffee" }
      expect(http_status).to eq(200)
      expect(response_json["access_token"]).to be_a(String)
      expect(response_json["client"]).to eq("Tasty Coffee")
    end
  end
end
