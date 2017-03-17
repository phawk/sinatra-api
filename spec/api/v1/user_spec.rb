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
        expect(response_json[:data][:name]).to eq alfred.name
        expect(response_json[:data][:email]).to eq alfred.email
      end
    end

  end

  describe "POST /v1/user/reset_password" do
    let!(:alfred) { create(:user) }

    before do
      authenticate_client
      post "/v1/user/reset_password", email: alfred.email
    end

    it "responds successfully" do
      expect(http_status).to eq 200
    end

    it "delivers a password reset email" do
      expect(last_email.to.first).to eq(alfred.email)
      expect(last_email.subject).to eq("Password reset instructions")
      expect(last_email.html_part.body).to include("reset your password")
    end
  end
end
