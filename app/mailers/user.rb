module Api
  module Mailers
    class User < BaseMailer
      def welcome(options)
        @options = options

        send to: options[:to], subject: "Welcome aboard!"
      end

      def password_reset(options)
        @options = options

        send to: options[:to], subject: "Password reset instructions"
      end

      def password_updated(options)
        @options = options

        send to: options[:to], subject: "Your password has been changed"
      end
    end
  end
end
