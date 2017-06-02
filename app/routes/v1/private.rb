module Api
  module Routes
    module V1
      class Private < Base
        get "/" do
          authenticate!
          json(private: "things")
        end
      end
    end
  end
end
