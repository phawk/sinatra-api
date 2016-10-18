require "sinatra/base"

# From: https://gist.github.com/bensie/4226520

module Sinatra
  module ErrorHandling

    module Helpers
      def halt_with_400_bad_request(message = nil)
        message ||= "Bad request"
        halt 400, json({ message: message })
      end

      def halt_with_401_authorization_required(message = nil, realm = "App Name")
        message ||= "Authorization required"
        headers 'WWW-Authenticate' => %(Basic realm="#{realm}")

        # Warden steps on 401s, set this message so wardens failure
        # app will use it and proxy it on to the end user
        request.env['warden.api.error'] = message
        halt 401, json({ message: message })
      end

      def halt_with_403_forbidden(message = nil)
        message ||= "Forbidden"
        halt 403, json({ message: message })
      end

      def halt_with_404_not_found(message = nil)
        message ||= "Resource not found"
        halt 404, json({ message: message })
      end

      def halt_with_422_unprocessible_entity
        errors = []
        resource = env['sinatra.error'].record.class.to_s
        env['sinatra.error'].record.errors.each do |attribute, message|

          code = case message
          when "can't be blank"
            "missing_field"
          when "has already been taken"
            "already_exists"
          else
            "invalid"
          end

          errors << {
            resource: resource,
            field: attribute,
            code: code
          }
        end
        halt 422, json({
          message: "Validation failed",
          errors: errors
        })
      end

      def halt_with_500_internal_server_error
        halt 500, json({
          message: "Internal server error: this is a problem on our end and we've been notified of the issue"
        })
      end
    end

    def self.registered(app)
      app.helpers ErrorHandling::Helpers

      app.error MultiJson::DecodeError do
        halt_with_400_bad_request("Problems parsing JSON")
      end

      app.error Sinatra::NotFound do
        status 404
        json({ error: "not_found", message: "Endpoint '#{request.path_info}' not found" })
      end

      app.error do
        # if ::Exceptional::Config.should_send_to_api?
        #   ::Exceptional::Remote.error(::Exceptional::ExceptionData.new(env['sinatra.error']))
        # end
        # err_name = env['sinatra.error'].name
        halt_with_500_internal_server_error
      end
    end
  end

  register ErrorHandling
end
