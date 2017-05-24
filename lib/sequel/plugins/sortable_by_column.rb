module Sequel
  module Plugins
    module SortableByColumn
      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :sort_by_column)

        def sortable_columns(*arr)
          class_variable_set(:@@allowed_sortable_columns, arr.map(&:to_sym))
        end
      end

      module DatasetMethods
        def sort_by_column(column, sort_order = nil)

          return order(:created_at) if column.blank?

          ensure_supported_column!(column)

          if String(sort_order).casecmp("desc").zero?
            order(Sequel.desc(column.to_sym))
          else
            order(column.to_sym)
          end
        end

        def ensure_supported_column!(column)
          begin
            allowed_cols = model.class_variable_get(:@@allowed_sortable_columns)
          rescue NameError
            raise "sortable_columns not set on model #{model.name}"
          end

          return true if allowed_cols.include?(column.to_sym)

          error_message = "Sort by column `#{column}` not permitted. Permitted columns #{allowed_cols}"
          raise BadRequest.new(error_message)
        end
      end

      class BadRequest < StandardError; end
    end
  end
end
