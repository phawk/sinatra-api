require "fast_helper"
require "app/validators/user_create_validator"

RSpec.describe UserCreateValidator do
  it "validates users" do
    validator = described_class.call(email: "", name: "John")

    expect(validator.to_h[:name]).to eq("John")

    expect(validator.success?).to be(false)
    expect(validator.errors.fetch(:email)).to eq(["must be filled"])
    expect(validator.errors.fetch(:password)).to eq(["is missing"])

    validator = described_class.call(email: "bob@bob", password: "abc")
    expect(validator.errors.fetch(:email)).to eq(["is in invalid format"])
    expect(validator.errors.fetch(:password)).to eq(["size cannot be less than 8"])
  end
end
