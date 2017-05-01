module Api
  module Routes
    class Main < Base
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

      get '/' do
        json(hello: "Api")
      end

      get '/mailer/preview' do
        content_type :html
        ::Api::Mailers::BaseMailer.new.render_sample
      end

      get '/api-docs.json' do
        JSON.dump(Swagger::Blocks.build_root_json([
          Api::Routes::Main,
          Api::Routes::OAuth::Token,
          Api::Routes::V1::CurrentUser,
          Api::Routes::V1::Users
        ]))
      end
    end
  end
end
