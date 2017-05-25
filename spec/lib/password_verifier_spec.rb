require "fast_helper"
require "password_verifier"
require "password_hasher"

RSpec.describe PasswordVerifier do
  it "verifies passwords" do
    digest  = PasswordHasher.new.hash_plaintext("hunter2")
    correct = PasswordVerifier.new(digest).verify("hunter2")
    invalid = PasswordVerifier.new(digest).verify("hunter3")

    expect(correct).to be(true)
    expect(invalid).to be(false)
  end

  it "fails gracefully with invalid hashes" do
    verifier = PasswordVerifier.new(nil)

    expect(verifier.verify(nil)).to be(false)
    expect(verifier.verify("")).to be(false)
    expect(verifier.verify("nil")).to be(false)
  end
end
