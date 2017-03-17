module Api
  class Base
    get '/' do
      json({ hello: "Api" })
    end

    get '/mailer/preview' do
      content_type :html
      ::Api::Mailers::BaseMailer.new.render_sample
    end
  end
end
