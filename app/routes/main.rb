module Api
  class Base
    get '/' do
      json({ hello: "Api" })
    end
  end
end
