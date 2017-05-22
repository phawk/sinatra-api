require "spec_helper"
require "app/use_cases/deliver_password_reset_token"

RSpec.describe DeliverPasswordResetToken do
  context "when user isn’t found" do
    it "does nothing" do
      subject.call("bad_email")
    end
  end

  context "when user exists" do
    let!(:alfred) { create(:user) }

    it "delivers a password reset email" do
      subject.call(alfred.email)

      expect(last_email.to.first).to eq(alfred.email)
      expect(last_email.subject).to eq("Password reset instructions")
      expect(last_email.html_part.body).to include("reset your password")
    end
  end
end
