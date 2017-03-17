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
    end
  end
end
