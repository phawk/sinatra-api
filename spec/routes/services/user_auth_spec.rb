require "spec_helper"

RSpec.describe "User Auth Service", type: :api do
  let(:email_address) { Faker::Internet.email }

  it "is mounted" do
    get "/auth"
    expect(http_status).to eq(200)
  end

  it "provides tokens" do
    post "/auth/signup", email: email_address, password: "mcflurries", info: { name: "Tester" }
    expect(http_status).to eq(201)
    expect(response_json["token_type"]).to eq("Bearer")
    expect(response_json["refresh_token"]).not_to be_nil

    payload = SigninToken.new.parse(response_json["token"])
    expect(payload["exp"]).to be_within(10).of(Time.now.to_i + 3600)
    expect(payload["email"]).to eq(email_address)
    expect(payload["user_id"]).to be_a(Numeric)
    expect(payload["name"]).to eq("Tester")
  end
end
