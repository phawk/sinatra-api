module Api
  module Helpers
    module Routes
      def self.included(other)
        other.class_eval do
          include Swagger::Blocks
        end
      end
    end
  end
end
