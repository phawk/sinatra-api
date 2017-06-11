require "json"
require "base64"
require "rack/test"
require "ostruct"

module ApiHelper
  include Rack::Test::Methods
  include Warden::Test::Helpers

  def app
    # Load entire Rack application stack
    Rack::Builder.parse_file(File.expand_path(File.join(__dir__, "..", "..", "config.ru"))).first
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

  def authenticate_as(id, email: "test@example.org")
    login_as OpenStruct.new(user_id: id, email: email)
    user_id
  end

  def token_header(user_id, email: "test@example.org")
    token = build_jwt(user_id: user_id, email: email)
    { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
  end

  # Response helpers

  def http_status
    last_response.status
  end

  # JSON helpers

  def response_json
    JSON.parse(last_response.body)
  end

  def json(hash)
    JSON.dump(hash)
  end

  # Token helpers

  def build_jwt(payload)
    JWT.encode(payload, ENV["JWT_SECRET_KEY"], "HS512")
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
  config.around(:each) do |example|
    Warden.test_mode!
    example.run
    Warden.test_reset!
  end
end
