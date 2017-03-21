class BaseSerializer
  include JSONAPI::Serializer

  def base_url
    'http://example.com'
  end
end
