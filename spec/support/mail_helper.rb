module MailHelper
  # Mail Helpers
  def last_email
    Mail::TestMailer.deliveries.last
  end

  def clear_email
    Mail::TestMailer.deliveries.clear
  end

  # Trying things
  #
  # it { must :respond_to, :name }
  #
  # def must(matcher, *args)
  #   subject.send("must_#{matcher.to_s}".to_sym, *args)
  # end
end

RSpec.configure do |config|
  config.include MailHelper
end
