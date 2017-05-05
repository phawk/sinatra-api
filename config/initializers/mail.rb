if %w[development production].include? ENV["RACK_ENV"]
  Mail.defaults do
    if ENV["RACK_ENV"] == "production"
      delivery_method Mail::Postmark, api_key: ENV["POSTMARK_API_KEY"], secure: true
    else
      delivery_method LetterOpener::DeliveryMethod, :location => File.expand_path("../../../tmp/letter_opener", __FILE__)
    end
  end
end
