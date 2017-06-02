require "spec_helper"

RSpec.describe "User Auth Service", type: :api do
  it "is mounted" do
    get "/auth"
    expect(http_status).to eq(200)
  end
end
