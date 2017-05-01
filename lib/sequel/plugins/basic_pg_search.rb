module Sequel
  module Plugins
    module BasicPgSearch
      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :basic_search)
      end

      module DatasetMethods
        def basic_search(keyword, cols:)
          if keyword
            full_text_search(cols, fts_param(keyword), language: "english")
          else
            self
          end
        end

        def fts_param(str)
          # Escape search chars and searches partial words
          String(str).gsub(/[^a-zA-Z0-9\s\@\.]/, "") + ":*"
        end
      end
    end
  end
end
