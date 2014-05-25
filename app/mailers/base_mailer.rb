require 'erb'

module Api
  module Mailers
    class BaseMailer
      DEFAULT_FROM = "pete@phawk.co.uk"

      def send(opts)
        current_mailer_method = caller_locations(1,1)[0].label

        mail = Mail.new
        mail.to = opts.fetch(:to)
        mail.from = DEFAULT_FROM
        mail.subject = opts.fetch(:subject)
        mail.body = template(current_mailer_method)
        mail.deliver
      end

      def get_binding
        binding
      end

      def help_page_url
        "#{frontend_url}/help"
      end

      def frontend_url
        "https://sinatra-api.herokuapp.com"
      end

    private

      def template(path)
        current_dir = File.expand_path(File.dirname(__FILE__))
        template_file = File.new(current_dir + "/templates/#{path}.erb").read
        template = ERB.new template_file, nil, "%"
        template.result(self.get_binding)
      end

    end
  end
end
