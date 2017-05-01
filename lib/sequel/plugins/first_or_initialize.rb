module Sequel
  module Plugins
    module FirstOrInitialize
      module ClassMethods
        def first_or_initialize(params)
          first(params) || new(params)
        end
      end
    end
  end
end
