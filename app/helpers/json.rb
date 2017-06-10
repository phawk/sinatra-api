require "active_support/core_ext/hash/conversions"
require "active_support/core_ext/hash/indifferent_access"

module Api
  module Helpers
    module Json
      def json(resource, opts = {})
        data = serialize(resource, opts)

        JSON.dump(data)
      end

      def serialize(resource, opts = {})
        # Calling #all ensures eager loading works before serialization
        resource = resource.all if resource.is_a?(Sequel::Dataset)

        if resource.is_a?(Array)
          JSONAPI::Serializer.serialize(resource.to_a, opts.merge(is_collection: true))
        elsif resource.is_a?(Sequel::Model)
          JSONAPI::Serializer.serialize(resource, opts.merge(skip_collection_check: true))
        elsif resource.is_a?(Hash)
          resource.merge(opts)
        else
          resource
        end
      end

      def page_meta(object, extra_meta = {})
        {
          "current-page" => object.current_page,
          "next-page" => object.next_page,
          "prev-page" => object.prev_page,
          "total-pages" => object.page_count,
          "total-count" => object.pagination_record_count
        }.merge(extra_meta)
      end

      def params
        super.symbolize_keys.with_indifferent_access
      end

      def true_value?(value)
        return false unless value
        return false if ["false", "0", 0].include?(value)
        true
      end
    end
  end
end
