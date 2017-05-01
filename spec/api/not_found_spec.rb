require "spec_helper"

RSpec.describe Api::Application, type: :api do
  describe "when a route doesn't exist" do
    it "returns a 404" do
      get_json "/hahaha"
      expect(http_status).to eq 404
      expect(response_json["error_code"]).to eq "not_found"
    end
  end
end
