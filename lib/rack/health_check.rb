module Rack
  class HealthCheck
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] == "/health"
        content = 'The app is alive!'
        return [200, { 'Content-Type' => 'text/html', 'Content-Length' => content.size.to_s }, [content]]
      end
      @app.call(env)
    end
  end
end
