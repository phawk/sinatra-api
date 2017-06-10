class UserAuthEmailJob
  include Sidekiq::Worker
  sidekiq_options queue: :critical

  def perform(options)
    case options.delete(:template)
    when "user_signup"
      Api::Mailers::User.new.welcome(options)
    when "password_reset"
      Api::Mailers::User.new.password_reset(options)
    when "password_updated"
      Api::Mailers::User.new.password_updated(options)
    end
  end
end
