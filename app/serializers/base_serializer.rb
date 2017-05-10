class BaseSerializer
  include JSONAPI::Serializer

  def base_url
    ENV.fetch("API_BASE_URL", "https://example.com") + "/v1"
  end

  def format_name(attribute_name)
    attribute_name.to_s
  end

  def unformat_name(attribute_name)
    attribute_name.to_s
  end
end
