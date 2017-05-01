module Api
  module Helpers
    module Errors
      def halt_bad_request(message = nil)
        message ||= "Bad request"
        halt 400, json(error_code: "bad_request", message: message)
      end

      def halt_authorization_required(message = nil, realm = "App Name")
        message ||= "Authorization required"
        headers "WWW-Authenticate" => %(Basic realm="#{realm}")

        # Warden steps on 401s, set this message so wardens failure
        # app will use it and proxy it on to the end user
        request.env["warden.api.error"] = message
        halt 401, json(error_code: "unauthorized", message: message)
      end

      def halt_forbidden(message = nil)
        message ||= "Forbidden"
        halt 403, json(error_code: "forbidden", message: message)
      end

      def halt_not_found(message = nil)
        message ||= "Resource not found"
        halt 404, json(error_code: "not_found", message: message)
      end

      def halt_unprocessible_entity(record, status_code: 422)
        halt status_code, json(
          errors: record.errors,
          error_code: "validation_failed",
          message: "Validation failed"
        )
      end

      def halt_internal_server_error
        halt 500, json(
          error_code: "internal_error",
          message: "Internal server error: this is a problem on our end and we've been notified of the issue"
        )
      end
    end
  end
end
