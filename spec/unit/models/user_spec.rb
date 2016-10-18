require_relative "../../spec_helper"

describe User do
  let(:user) { build(:user) }

  describe ".find_by_token" do
    let(:valid_jwt) { get_jwt({ "user_id" => 1, "expires" => 24.hours.from_now }) }
    let(:expired_jwt) { get_jwt({ "user_id" => 1, "expires" => 5.minutes.ago }) }

    describe "decode error" do
      it { User.find_by_token("gibberish").must_be_nil }
    end

    describe "expired" do
      it { User.find_by_token(expired_jwt).must_be_nil }
    end

    describe "valid" do
      it "finds the user" do
        User.expects(:find).with(1).returns(user)
        User.find_by_token(valid_jwt).must_equal user
      end
    end
  end

  describe "#fields" do
    subject { user }

    it { subject.must_respond_to :name }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :password }
    it { subject.must_respond_to :access_tokens }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe "#email" do
    it "ensures presence" do
      user.email = nil
      user.valid?.must_equal false
    end

    it "ensures valid" do
      user.email = "fake"
      user.valid?.must_equal false
    end

    it "is unique" do
      user.save.must_equal true
      new_user = build(:user, email: user.email)
      new_user.save.must_equal false
    end
  end

  describe "#password" do
    it "ensures presence" do
      user = User.new(email: "bob@bob.com")
      user.valid?.must_equal false
    end

    it "uses bcrypt" do
      user = User.new(email: "bob@bob.com", password: "superduper")
      user.password.to_s.must_match(/^\$2a/)
      user.password = "hunter2"
      user.password.to_s.must_match(/^\$2a/)
      (user.password == "hunter2").must_equal true
    end
  end

  describe "#public_params" do
    subject { User.new(id: 121, name: "Jimmy", email: "jim@jim.com", created_at: Time.now) }

    it { subject.public_params.keys.must_be :==, ["id", "name", "email", "created_at"] }
  end

  describe "#reset_password" do
    subject { User.new(name: "Jimmy", email: "jimmy@example.org") }

    it "sends a password reset email" do
      subject.reset_password
      last_email.subject.must_match(/Password reset/)
      last_email.to.first.must_equal subject.email
      last_email.body.to_s.must_match(/\/users\/reset_password\//)
    end
  end

  describe "#update_password" do
    subject { User.new(name: "Jimmy") }

    describe "when password is too short" do
      it "has errors" do
        subject.update_password("test")
        subject.errors.wont_be_empty
      end
    end

    describe "when password is valid" do
      it "resets password" do
        subject.update_password("testpassword")
        (subject.password == "testpassword").must_equal true
      end
    end
  end

end
