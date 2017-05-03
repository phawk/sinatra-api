require "json"
require "fast_helper"
require "token_failure_app"
require "rack/test"

RSpec.describe TokenFailureApp do
  include Rack::Test::Methods

  def app
    TokenFailureApp
  end

  it "returns unathorized status" do
    post "/unauthenticated"
    expect(last_response.status).to eq(401)
    expect(last_response.content_type).to eq("application/json")
    expect(JSON.parse(last_response.body)["error"]).to eq("authentication_failed")
  end
end
