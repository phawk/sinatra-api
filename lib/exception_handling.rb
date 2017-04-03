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

      if ENV['RACK_ENV'] == 'development'
        hash = { :message => ex.to_s, :backtrace => ex.backtrace }
      else
        hash = { :message => "Internal server error" }
      end

      [500, {'Content-Type' => 'application/json'}, [JSON.dump(hash)]]
    end
  end
end
