require "json"
require "raven"

Raven.configure do |config|
  config.tags = { environment: ENV["APP_ENV"] }
  config.environments = %w[staging production]
  config.excluded_exceptions = %w[ActiveRecord::RecordNotFound]
end

class ExceptionHandling
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call env
  rescue StandardError => e
    raise e if ENV["APP_ENV"] == "test"

    log_exception(env, e)
    rack_response(build_exception_hash(e))
  end

  private

  def rack_response(hash)
    [500, { "Content-Type" => "application/json" }, [JSON.dump(hash)]]
  end

  def build_exception_hash(exception)
    hash = {
      error_code: "internal_error",
      message: "Internal server error: this is a problem on our end and we've been notified of the issue"
    }

    if ENV["APP_ENV"] == "development"
      hash[:message] = exception.to_s
      hash[:backtrace] = exception.backtrace
    end

    hash
  end

  def log_exception(env, exception)
    # Send errors to sentry.io
    Raven.capture_exception(exception)

    env["rack.errors"].puts exception
    env["rack.errors"].puts exception.backtrace.join("\n")
    env["rack.errors"].flush
  end
end
