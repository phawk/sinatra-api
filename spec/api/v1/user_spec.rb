require "spec_helper"

describe "Api::v1::UserStory", type: :api do
  describe "GET /v1/user" do

    describe "not authentication" do
      before { get "/v1/user" }

      it "responds with a 401" do
        expect(http_status).to eq 401
      end
    end

    describe "authenticated" do
      let(:alfred) { create(:user) }
      before do
        authenticate_as alfred
        get "/v1/user"
      end

      it "responds successfully" do
        expect(http_status).to eq 200
      end

      it "shows my details" do
        expect(json_response[:name]).to eq alfred.name
        expect(json_response[:email]).to eq alfred.email
      end
    end

  end
end
