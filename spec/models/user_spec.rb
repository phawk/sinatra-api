require "spec_helper"

RSpec.describe User, type: :model do
  subject { build_stubbed(:user) }

  describe ".first_or_initialize" do
    let(:user) { create(:user) }

    it "tries to load a model before initializing" do
      expect(User.first_or_initialize(email: user.email).new?).to be(false)

      non_existant = User.first_or_initialize(email: "bad_email101")
      expect(non_existant.new?).to be(true)
      expect(non_existant.email).to eq("bad_email101")
    end
  end

  describe ".basic_search" do
    let(:user) { create(:user) }

    it "finds things" do
      results = User.basic_search(user.name).to_a
      expect(results.size).to eq(1)
      expect(results.first.id).to eq(user.id)
    end
  end

  describe "#fields" do
    it { expect(subject).to respond_to(:name) }
    it { expect(subject).to respond_to(:email) }
    it { expect(subject).to respond_to(:password) }
    it { expect(subject).to respond_to(:access_tokens) }
    it { expect(subject).to respond_to(:created_at) }
    it { expect(subject).to respond_to(:updated_at) }
  end

  describe "#authenticate" do
    it "checks passwords match" do
      expect(User.new.authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("hunter2")).to be(true)
    end
  end

  describe "#password" do
    it "uses bcrypt" do
      user = User.new(email: "bob@bob.com", password: "superduper")
      user.password = "hunter2"
      expect(user.authenticate("hunter2")).to be true
    end
  end

  describe "#update_password" do
    subject { User.new(name: "Jimmy", email: "jimmy@eatsworld.com") }

    describe "when password is valid" do
      it "resets password" do
        subject.update_password("testpassword")
        expect(subject.password == "testpassword").to be true
      end
    end
  end
end
