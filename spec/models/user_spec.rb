require "spec_helper"

describe User, type: :model do
  subject { create(:user) }

  describe ".find_by_token" do
    let(:valid_jwt) { get_jwt({ "user_id" => 1, "expires" => 24.hours.from_now }) }
    let(:expired_jwt) { get_jwt({ "user_id" => 1, "expires" => 5.minutes.ago }) }

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

  describe "#fields" do
    it { expect(subject).to respond_to(:name) }
    it { expect(subject).to respond_to(:email) }
    it { expect(subject).to respond_to(:password) }
    it { expect(subject).to respond_to(:access_tokens) }
    it { expect(subject).to respond_to(:created_at) }
    it { expect(subject).to respond_to(:updated_at) }
  end

  describe "#email" do
    it "ensures presence" do
      subject.email = nil
      expect(subject.valid?).to be false
    end

    it "ensures valid" do
      subject.email = "fake"
      expect(subject.valid?).to be false
    end

    it "is unique" do
      expect(subject.valid?).to be true
      new_user = build(:user, email: subject.email)
      expect(new_user.valid?).to be false
    end
  end

  describe "#authenticate" do
    it "checks passwords match" do
      expect(User.new.authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("password")).to be(false)
      expect(User.new(password: "hunter2").authenticate("hunter2")).to be(true)
    end
  end

  describe "#password" do
    it "ensures presence" do
      user = User.new(email: "bob@bob.com")
      expect(user.valid?).to be false
    end

    it "uses bcrypt" do
      user = User.new(email: "bob@bob.com", password: "superduper")
      user.password = "hunter2"
      expect(user.authenticate("hunter2")).to be true
    end
  end

  describe "#reset_password" do
    subject { User.new(name: "Jimmy", email: "jimmy@example.org") }

    it "sends a password reset email" do
      subject.reset_password
      expect(last_email.subject).to match(/Password reset/)
      expect(last_email.to.first).to eq(subject.email)
      expect(last_email.html_part.body.to_s).to match(/\/users\/reset_password\//)
    end
  end

  describe "#update_password" do
    subject { User.new(name: "Jimmy", email: "jimmy@eatsworld.com") }

    describe "when password is too short" do
      it "has errors" do
        subject.update_password("test")
        expect(subject.errors).not_to be(:empty)
      end
    end

    describe "when password is valid" do
      it "resets password" do
        puts "SUBJECT: #{subject.inspect}"
        subject.update_password("testpassword")
        expect(subject.password == "testpassword").to be true
      end
    end
  end

end
