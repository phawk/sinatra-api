require_relative "../story_helper"

describe "SiteStory" do
  describe "the homepage" do
    it "hello world" do
      get '/'
      last_response.body.must_include "hello"
    end
  end

  describe "when a route doesn't exist" do
    before { get_json '/hahaha' }

    it { http_status.must_equal 404 }
    it { json_response[:error].must_equal "not_found" }
  end
end
