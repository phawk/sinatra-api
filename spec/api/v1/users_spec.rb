require "spec_helper"

describe "Api::v1::UsersStory", type: :api do
  describe "POST /v1/users" do
    before do
      authenticate_client
    end

    it "has validation" do
      post "/v1/users", { name: "Batman" }

      expect(http_status).to eq(400)
      expect(response_json[:data][:message]).to match(/Validation failed/)
      expect(response_json[:data][:errors]).not_to be_nil
    end

    it "creates a user and returns an api token" do
      post "/v1/users", { name: "Batman", email: "batman@robin.com", password: "supersecretpassword" }

      puts response_json
      expect(http_status).to eq(200)
    end
  end
end
