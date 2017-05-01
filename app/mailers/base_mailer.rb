require "erb"

module Api
  module Mailers
    class BaseMailer
      DEFAULT_FROM = "no-reply@example.org".freeze

      def render_sample
        template("sample")
      end

      def send(opts)
        current_mailer_method = caller_locations(1, 1)[0].label
        html = template(current_mailer_method)

        deliver_html_email(html, to: opts.fetch(:to), subject: opts.fetch(:subject))
      end

      def deliver_html_email(html, to:, subject:)
        mail = Mail.new
        mail.to = to
        mail.from = DEFAULT_FROM
        mail.subject = subject
        mail.html_part = Mail::Part.new do
          content_type "text/html; charset=UTF-8"
          body(html)
        end
        mail.deliver
      end

      def help_page_url
        "#{frontend_url}/help"
      end

      def frontend_url
        "https://sinatra-api.herokuapp.com"
      end

      private

      def template(path)
        current_dir   = File.expand_path(File.dirname(__FILE__))
        layout_file   = File.new(current_dir + "/templates/layout.erb").read
        template_file = File.new(current_dir + "/templates/#{path}.erb").read

        templates = [template_file, layout_file]
        templates.inject(nil) do |prev, temp|
          _render(temp) { prev }
        end
      end

      def _render(temp)
        ERB.new(temp, nil, "%").result(binding)
      end
    end
  end
end
