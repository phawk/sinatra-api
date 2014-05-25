module StoryHelpers

  FakeToken = Struct.new(:user)

  # Request helpers

  def get_json(path)
    get path
    json_response
  end

  def post_json(url, data)
    post(url, json(data), { "CONTENT_TYPE" => "application/json" })
    json_response
  end

  def authenticate_as(user)
    login_as FakeToken.new(user)
    user
  end

  # Response helpers

  def http_status
    last_response.status
  end

  def json_response
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
