require "spec_helper"

RSpec.describe Api::Application, type: :api do
  describe "when a route doesn't exist" do
    before { get_json '/hahaha' }

    it { expect(http_status).to eq 404 }
    it { expect(response_json["error_code"]).to eq "not_found" }
  end
end
