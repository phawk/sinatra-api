require 'json'

class ExceptionHandling
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call env
    rescue => ex
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
