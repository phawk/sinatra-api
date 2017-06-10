module Api
  module Helpers
    module Auth
      def warden
        env["warden"]
      end

      # Soft authenticate - sets warden.user if strategy passes
      #                   - does nothing if strategy fails
      def authenticate
        warden.authenticate(:jwt)
      end

      # Hard authenticate - sets warden.user if strategy passes
      #                   - returns 401 if strategy fails
      def authenticate!
        warden.authenticate!
      end

      def current_user
        @current_user ||= warden.user
      end
    end
  end
end
