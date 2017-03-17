module Api
  class Base
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Sinatra API'
        key :description, 'Sinatra API with oAuth and user endpoints'
      end
    end

    get '/' do
      json({ hello: "Api" })
    end

    get '/mailer/preview' do
      content_type :html
      ::Api::Mailers::BaseMailer.new.render_sample
    end

    get '/docs' do
      json Swagger::Blocks.build_root_json([
        Api::Base
      ])
    end
  end
end
