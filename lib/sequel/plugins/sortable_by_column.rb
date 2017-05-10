module Sequel
  module Plugins
    module SortableByColumn
      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :sort_by_column)
      end

      module DatasetMethods
        def sort_by_column(column, sort_order = nil, allowed_cols:)
          return order(:created_at) if column.blank?

          ensure_supported_column!(column, allowed_cols)

          if String(sort_order).casecmp("desc").zero?
            order(Sequel.desc(column.to_sym))
          else
            order(column.to_sym)
          end
        end

        def ensure_supported_column!(column, allowed_cols)
          return true if allowed_cols.include?(column.to_sym)

          error_message = "Sort by column `#{column}` not permitted. Permitted columns #{allowed_cols.to_sentence}"
          raise BadRequest.new(error_message)
        end
      end

      class BadRequest < StandardError; end
    end
  end
end
