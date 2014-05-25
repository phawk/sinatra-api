require_relative "../../story_helper"

describe "Api::v1::UserStory" do
  describe "GET /v1/user" do

    describe "not authentication" do
      before { get "/v1/user" }

      it "responds with a 401" do
        http_status.must_equal 401
      end
    end

    describe "authenticated" do
      let(:alfred) { create(:user) }
      before do
        authenticate_as alfred
        get "/v1/user"
      end

      it "responds successfully" do
        http_status.must_equal 200
      end

      it "shows my details" do
        json_response[:name].must_equal alfred.name
        json_response[:email].must_equal alfred.email
      end
    end

  end
end
