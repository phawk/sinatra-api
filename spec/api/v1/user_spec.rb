require "spec_helper"

RSpec.describe "Api::v1::UserStory", type: :api do
  describe "GET /v1/user" do
    context "not authentication" do
      before { get "/v1/user" }

      it "responds with a 401" do
        expect(http_status).to eq 401
      end
    end

    context "authenticated" do
      let(:alfred) { create(:user) }
      before do
        authenticate_as alfred
        get "/v1/user"
      end

      it "responds successfully" do
        expect(http_status).to eq 200
      end

      it "shows my details" do
        expect(json_attrs["name"]).to eq alfred.name
        expect(json_attrs["email"]).to eq alfred.email
      end
    end
  end

  describe "POST /v1/user/reset_password" do
    let!(:alfred) { create(:user) }

    before do
      authenticate_client
      post_json "/v1/user/reset_password", email: alfred.email
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

  describe "PUT /v1/user/attributes/password" do
    let(:alfred) { create(:user) }
    let(:valid_jwt) { get_jwt({ "user_id" => alfred.id, "expires" => 24.hours.from_now }) }
    let(:expired_jwt) { get_jwt({ "user_id" => alfred.id, "expires" => 5.minutes.ago }) }

    before do
      authenticate_client
    end

    it "requires a reset token" do
      put "/v1/user/attributes/password", { password: "updated_password" }

      expect(http_status).to eq(404)
      expect(response_json["message"]).to match(/No user found for reset token/)
    end

    it "requires the reset token to have not expired" do
      put "/v1/user/attributes/password", { password: "updated_password", reset_token: expired_jwt }

      expect(http_status).to eq(404)
      expect(response_json["message"]).to match(/No user found for reset token/)
    end

    it "updates the password" do
      put "/v1/user/attributes/password", { password: "updated_password", reset_token: valid_jwt }

      expect(http_status).to eq(200)
      expect(response_json["data"]["message"]).to match(/Password has been reset/)
    end
  end
end
