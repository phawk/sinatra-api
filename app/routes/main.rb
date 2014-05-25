module Api
  class Base
    get '/' do
      json({ hello: "Api" })
    end

    error Sinatra::NotFound do
      status 404
      json({ error: "not_found", message: "Endpoint '#{request.path_info}' not found" })
    end

    error do
      err_name = env['sinatra.error'].name
      status 500
      json({ error: err_name, message: "Sorry there was a nasty error - #{err_name}" })
    end
  end
end
