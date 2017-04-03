require 'json'
require 'raven'

Raven.configure do |config|
  config.tags = { environment: ENV['RACK_ENV'] }
  config.environments = %w(staging production)
  # config.excluded_exceptions = %w(Sequel::Error)
end

class ExceptionHandling
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call env
    rescue => ex
      # Send errors to sentry.io
      Raven.capture_exception(ex)

      env['rack.errors'].puts ex
      env['rack.errors'].puts ex.backtrace.join("\n")
      env['rack.errors'].flush

      hash = {
        error_code: "internal_error",
        message: "Internal server error: this is a problem on our end and we've been notified of the issue"
      }

      if ENV['RACK_ENV'] == 'development'
        hash[:message] = ex.to_s
        hash[:backtrace] = ex.backtrace
      end

      [500, {'Content-Type' => 'application/json'}, [JSON.dump(hash)]]
    end
  end
end
