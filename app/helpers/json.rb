module Api
  module Helpers
    module Json
      def json(resource, meta: {}, opts: {})
        data = serialize(resource, opts)

        data[:meta] = meta if meta.any?

        MultiJson.dump(data, pretty: true)
      end

      def serialize(resource, opts = {})
        if resource.is_a?(ActiveRecord::Relation) && resource.respond_to?(:map)
          JSONAPI::Serializer.serialize(resource, is_collection: true)
        elsif resource.is_a?(ActiveRecord::Base)
          JSONAPI::Serializer.serialize(resource, opts)
        elsif resource.is_a?(Hash)
          resource
        else
          resource
        end
      end

      def page_meta(object, extra_meta = {})
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }.merge(extra_meta)
      end

      def params
        super.with_indifferent_access
      end
    end
  end
end
