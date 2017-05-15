require "spec_helper"

RSpec.describe Api::Routes::Main, type: :api do
  describe "requesting static files" do
    it do
      get "/robots.txt"
      expect(http_status).to eq 200
      expect(last_response.body).to include("Disallow")
    end
  end
end
