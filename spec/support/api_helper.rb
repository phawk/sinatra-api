require "json"
require "base64"
require "rack/test"

module ApiHelper
  include Rack::Test::Methods
  include Warden::Test::Helpers

  FakeToken = Struct.new(:user)
  FakeClientToken = Struct.new(:client_application)

  def app
    # If described class is a sinatra app only test against it directly
    # and not the entire application
    if !described_class.nil? && described_class <= Sinatra::Base
      described_class
    else
      Api::Application
    end
  end

  # Request helpers

  def get_json(path)
    get path
    response_json
  end

  def post_json(url, data)
    post(url, json(data), "CONTENT_TYPE" => "application/json")
    response_json
  end

  def authenticate_as(user)
    login_as FakeToken.new(user)
    user
  end

  def authenticate_client(client = nil)
    client ||= build_stubbed(:client_application)
    login_as FakeClientToken.new(client), strategy: :client_secret
    client
  end

  def token_header(user)
    access_token = create(:access_token, user: user)
    { "HTTP_AUTHORIZATION" => "Bearer #{access_token.token}" }
  end

  def basic_header(username, password)
    auth = Base64.strict_encode64("#{username}:#{password}")
    { "HTTP_AUTHORIZATION" => "Basic #{auth}" }
  end

  # Response helpers

  def http_status
    last_response.status
  end

  # JSON helpers

  def json_attrs
    response_json["data"]["attributes"]
  end

  def response_json
    JSON.parse(last_response.body)
  end

  def json(hash)
    JSON.dump(hash)
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
