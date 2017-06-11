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
      expect(last_email.body.parts.first.to_s).to include("Welcome")
      expect(last_email.body.parts.first.to_s).to include("Tester")
    end
  end

  describe "#password_reset" do
  end

  describe "#password_updated" do
  end
end
