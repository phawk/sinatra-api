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
        if resource.is_a?(ActiveRecord::Relation) && resource.respond_to?(:map)
          JSONAPI::Serializer.serialize(resource, opts.merge(is_collection: true))
        elsif resource.is_a?(ActiveRecord::Base)
          JSONAPI::Serializer.serialize(resource, opts)
        elsif resource.is_a?(Hash)
          resource.merge(opts)
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
