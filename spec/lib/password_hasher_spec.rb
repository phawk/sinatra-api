require "fast_helper"
require "password_hasher"
require "password_verifier"

RSpec.describe PasswordHasher do
  it "hashes passwords" do
    digest = subject.hash_plaintext("hunter2")
    correct = PasswordVerifier.new(digest).verify("hunter2")
    invalid = PasswordVerifier.new(digest).verify("hunter3")

    expect(correct).to be(true)
    expect(invalid).to be(false)
  end
end
