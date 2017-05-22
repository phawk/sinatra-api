require "spec_helper"

RSpec.describe Api::Routes::V1::CurrentUser, type: :api do
  describe "GET /v1/user" do
    context "not authentication" do
      it "responds with a 401" do
        get "/v1/user"
        expect(http_status).to eq 401
      end
    end

    context "authenticated" do
      let!(:alfred) { authenticate_as(create(:user)) }

      it "returns my details" do
        get "/v1/user"
        expect(http_status).to eq 200
        expect(json_attrs["name"]).to eq alfred.name
        expect(json_attrs["email"]).to eq alfred.email
      end
    end
  end

  describe "POST /v1/user/reset_password" do
    let!(:alfred) { create(:user) }

    it "delivers a password reset email" do
      authenticate_client
      post_json "/v1/user/reset_password", email: alfred.email
      expect(http_status).to eq 200
      expect(last_email.to.first).to eq(alfred.email)
      expect(last_email.subject).to eq("Password reset instructions")
      expect(last_email.html_part.body).to include("reset your password")
    end
  end

  describe "PUT /v1/user/attributes/password" do
    let(:alfred) { create(:user) }
    let(:valid_jwt) { SigninToken.new.create(user_id: alfred.id, exp: 24.hours.from_now.to_i) }
    let(:expired_jwt) { SigninToken.new.create(user_id: alfred.id, exp: 5.minutes.ago.to_i) }

    before do
      authenticate_client
    end

    it "requires a reset token" do
      put "/v1/user/attributes/password", password: "updated_password"

      expect(http_status).to eq(400)
      expect(response_json["message"]).to match(/Invalid token/)
    end

    it "requires the reset token to have not expired" do
      put "/v1/user/attributes/password", password: "updated_password", reset_token: expired_jwt

      expect(http_status).to eq(400)
      expect(response_json["message"]).to match(/Token expired/)
    end

    it "requires the password to be gt 8 chars" do
      put "/v1/user/attributes/password", password: "upd", reset_token: valid_jwt

      expect(http_status).to eq(422)
      expect(response_json["errors"]["password"]).to eq(["size cannot be less than 8"])
    end

    it "updates the password" do
      put "/v1/user/attributes/password", password: "updated_password", reset_token: valid_jwt

      expect(http_status).to eq(200)
      expect(response_json["data"]["message"]).to match(/Password has been reset/)
    end
  end
end
