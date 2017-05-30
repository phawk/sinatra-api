module Sequel
  module Plugins
    module BasicPgSearch
      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :basic_search)

        def searchable_columns(*arr)
          class_variable_set(:@@allowed_searchable_columns, arr.map(&:to_sym))
        end
      end

      module DatasetMethods
        def basic_search(keyword)
          begin
            cols = model.class_variable_get(:@@allowed_searchable_columns)
          rescue NameError
            raise "searchable_columns not set on model #{model.name}"
          end

          if keyword
            full_text_search(cols, fts_param(keyword), language: "english")
          else
            self
          end
        end

        def fts_param(str)
          # Escape search chars and searches partial words
          safe = String(str).gsub(/[^a-zA-Z0-9\s\@\.]/, " ")
          safe = safe.split(" ").map { |v| "\"#{v}\"" }.join("|")
          "#{safe}:*"
        end
      end
    end
  end
end
