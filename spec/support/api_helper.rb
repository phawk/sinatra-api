require 'rack/test'

module ApiHelper
  include Rack::Test::Methods
  include Warden::Test::Helpers

  FakeToken = Struct.new(:user)

  def app
    Api::Base
  end

  # Request helpers

  def get_json(path)
    get path
    response_json
  end

  def post_json(url, data)
    post(url, json(data), { "CONTENT_TYPE" => "application/json" })
    response_json
  end

  def authenticate_as(user)
    login_as FakeToken.new(user)
    user
  end

  def authenticate_client(client = nil)
    client = client || create(:client_application)
    login_as AccessToken.for_client(client), strategy: :client_secret
    client
  end

  # Response helpers

  def http_status
    last_response.status
  end

  def response_json
    parse_json last_response.body
  end

  # JSON helpers

  def parse_json(body)
    MultiJson.load(body, symbolize_keys: true)
  end

  def json(hash)
    MultiJson.dump(hash, pretty: true)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api # apply to all specs for apis folder
  config.around(:each) do |example|
    Warden.test_mode!
    example.run
    Warden.test_reset!
  end
end
