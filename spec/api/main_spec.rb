require "spec_helper"

RSpec.describe Api::Routes::Main, type: :api do
  describe "the homepage" do
    it "hello world" do
      get '/'
      expect(last_response.body).to include("hello")
    end
  end
end
