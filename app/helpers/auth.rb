module Api
  module Helpers
    module Auth
      def warden
        env["warden"]
      end

      def ensure_client!
        warden.authenticate! :access_token, :client_id

        # If we use client_id auth we need to set the current client manually
        @oauth_client = env["warden.oauth_client"] if env["warden.oauth_client"]
      end

      def ensure_client_secret!
        warden.authenticate! :client_secret

        # If we use client_secret auth we need to set the current client manually
        @oauth_client = env["warden.oauth_client"] if env["warden.oauth_client"]
      end

      def authenticate!
        warden.authenticate!
      end

      def current_token
        @current_token ||= warden.user
      end

      def current_user
        @current_user ||= current_token&.user
      end

      def current_client
        @oauth_client ||= current_token&.client_application
      end
    end
  end
end
