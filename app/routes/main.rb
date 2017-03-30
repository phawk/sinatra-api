module Api
  class Base
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Sinatra API'
        key :description, 'Sinatra API with oAuth and user endpoints'
      end
      security_definition :access_token do
        key :type, :apiKey
        key :name, :access_token
        key :in, :query
      end
    end

    get '/broken' do
      $log.info "Visiting broken endpoint"
      fail 'bad.'
    end

    get '/' do
      json({ hello: "Api" })
    end

    get '/mailer/preview' do
      content_type :html
      ::Api::Mailers::BaseMailer.new.render_sample
    end

    get '/api-docs.json' do
      docs = Swagger::Blocks.build_root_json([Api::Base])
      MultiJson.dump(docs)
    end
  end
end
