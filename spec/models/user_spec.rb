require "spec_helper"

RSpec.describe User, type: :model do
  subject { User.first }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value("pete@example.org").for(:email) }
  it { is_expected.not_to allow_value("pete.org").for(:email) }

  describe ".find_by_token" do
    let(:valid_jwt) { build_jwt({ "user_id" => 1, "exp" => 24.hours.from_now.to_i }) }
    let(:expired_jwt) { build_jwt({ "user_id" => 1, "exp" => 5.minutes.ago.to_i }) }

    describe "decode error" do
      it { expect(User.find_by_token("gibberish")).to be_nil }
    end

    describe "expired" do
      it { expect(User.find_by_token(expired_jwt)).to be_nil }
    end

    describe "valid" do
      it "finds the user" do
        allow(User).to receive(:find).and_return(subject)
        expect(User.find_by_token(valid_jwt)).to eq(subject)
      end
    end
  end

  describe "#authenticate" do
    it "checks passwords match" do
      expect(User.new.authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("hunter2")).to be(true)
    end
  end

  describe "#signin_token" do
    it "generations a JWT" do
      expect(User.new(id: 12).signin_token).not_to be_nil
    end
  end

  describe "email=" do
    it "downcases where possible" do
      user = User.new(email: " Pete@example.org ")
      expect(user.email).to eq("pete@example.org")
    end

    it "allows setting back to nil" do
      subject.email = nil
      expect(subject.email).to be_nil
    end
  end

  def build_jwt(payload)
    JWT.encode(payload, ENV["JWT_SECRET_KEY"], "HS512")
  end
end
