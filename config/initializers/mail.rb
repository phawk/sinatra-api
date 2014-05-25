Mail.defaults do
  delivery_method Mail::Postmark, api_key: ENV['POSTMARK_API_KEY'], secure: true
end
