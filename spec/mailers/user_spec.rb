require "spec_helper"

RSpec.describe Api::Mailers::User do
  describe "#welcome" do
    it "sends a welcome email" do
      subject.welcome(
        to: "test@example.org",
        user: {
          name: "Tester"
        }
      )

      expect(last_email.to.first).to eq("test@example.org")
      expect(last_email.subject).to eq("Welcome aboard!")

      body = last_email.body.parts.first.to_s
      expect(body).to include("Welcome")
      expect(body).to include("Tester")
    end
  end

  describe "#password_reset" do
    it "sends a password reset email" do
      subject.password_reset(
        to: "test@example.org",
        user: {
          name: "Tester"
        },
        reset_token: "abc123"
      )

      expect(last_email.to.first).to eq("test@example.org")
      expect(last_email.subject).to eq("Password reset instructions")

      body = last_email.body.parts.first.to_s
      expect(body).to include("reset")
      expect(body).to include("Tester")
      expect(body).to include("abc123")
    end
  end

  describe "#password_updated" do
    it "sends a password updated email" do
      subject.password_updated(
        to: "test@example.org",
        user: {
          name: "Tester"
        }
      )

      expect(last_email.to.first).to eq("test@example.org")
      expect(last_email.subject).to eq("Your password has been changed")

      body = last_email.body.parts.first.to_s
      expect(body).to include("Tester")
    end
  end
end
