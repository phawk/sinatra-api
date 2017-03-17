require "spec_helper"

describe "Site", type: :api do
  describe "the homepage" do
    it "hello world" do
      get '/'
      expect(last_response.body).to include("hello")
    end
  end

  describe "when a route doesn't exist" do
    before { get_json '/hahaha' }

    it { expect(http_status).to eq 404 }
    it { expect(response_json[:data][:error_code]).to eq "not_found" }
  end
end
