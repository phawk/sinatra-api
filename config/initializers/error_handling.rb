require "sinatra/base"

# From: https://gist.github.com/bensie/4226520

module Sinatra
  module ErrorHandling

    module Helpers
      def halt_bad_request(message = nil)
        message ||= "Bad request"
        halt 400, json({ error_code: "bad_request", message: message })
      end

      def halt_authorization_required(message = nil, realm = "App Name")
        message ||= "Authorization required"
        headers 'WWW-Authenticate' => %(Basic realm="#{realm}")

        # Warden steps on 401s, set this message so wardens failure
        # app will use it and proxy it on to the end user
        request.env['warden.api.error'] = message
        halt 401, json({ error_code: "unauthorized", message: message })
      end

      def halt_forbidden(message = nil)
        message ||= "Forbidden"
        halt 403, json({ error_code: "forbidden", message: message })
      end

      def halt_not_found(message = nil)
        message ||= "Resource not found"
        halt 404, json({ error_code: "not_found", message: message })
      end

      def halt_unprocessible_entity(record, status_code: 422)
        errors = record.errors.map do |attribute, message|
          code = case message
          when "can't be blank"
            "missing_field"
          when "has already been taken"
            "already_exists"
          else
            "invalid"
          end

          {
            resource: record.class.to_s,
            field: attribute,
            code: code
          }
        end
        halt status_code, json({
          error_code: "validation_failed",
          message: "Validation failed",
          errors: errors
        })
      end

      def halt_internal_server_error
        halt 500, json({
          error_code: "internal_error",
          message: "Internal server error: this is a problem on our end and we've been notified of the issue"
        })
      end
    end

    def self.registered(app)
      app.helpers ErrorHandling::Helpers

      app.error MultiJson::DecodeError do
        halt_bad_request("Problems parsing JSON")
      end

      app.error Sinatra::NotFound do
        halt_not_found("Endpoint '#{request.path_info}' not found")
      end

      app.error do
        # err_name = env['sinatra.error'].name
        halt_internal_server_error
      end
    end
  end

  register ErrorHandling
end
