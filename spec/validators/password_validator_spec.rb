require "fast_helper"
require "app/validators/password_validator"

RSpec.describe PasswordValidator do
  it "requires a password" do
    validator = described_class.call(password: "")
    expect(validator.success?).to be(false)
    expect(validator.errors.fetch(:password)).to eq(["must be filled"])

    validator = described_class.call(password: "abc")
    expect(validator.success?).to be(false)
    expect(validator.errors.fetch(:password)).to eq(["size cannot be less than 8"])
  end
end
