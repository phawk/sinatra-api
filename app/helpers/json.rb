module Api
  module Helpers
    module Json
      def json(resource, meta: {}, opts: {})
        data = { data: serialize(resource, opts) }

        data[:meta] = meta if meta.any?

        MultiJson.dump(data, pretty: true)
      end

      def serialize(resource, opts = {})
        if resource.is_a?(ActiveRecord::Relation) && resource.respond_to?(:map)
          resource.map { |r| ActiveModelSerializers::SerializableResource.new(r, opts) }
        elsif resource.is_a?(ActiveRecord::Base)
          ActiveModelSerializers::SerializableResource.new(resource, opts)
        else
          resource
        end
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
