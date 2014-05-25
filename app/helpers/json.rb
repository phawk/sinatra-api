module Api
  module Helpers
    module Json
      def json(hash)
        MultiJson.dump(hash, pretty: true)
      end

      # Parse the request body and enforce that it is a JSON hash
      def parsed_params
        if request.get? || request.form_data?
          parsed = params
        else
          request.body.rewind
          parsed = MultiJson.load(request.body.read, symbolize_keys: true)
        end

        raise MultiJson::ParseError("Params is not a hash") unless parsed.is_a?(Hash)

        return parsed
      rescue MultiJson::ParseError => e
        halt_with_400_bad_request("The request body you provide must be a JSON hash")
      end
    end
  end
end
