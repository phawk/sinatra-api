require "user_auth"

UserAuth.configure do |config|
  # Lambda that gets called each time an email should be delivered
  # configure this with however your application sends email.
  config.deliver_mail = lambda do |params|
    # example params =>
    # {
    #   template: "user_signup",
    #   to: "email@email.com",
    #   user: {
    #     user_id: 123,
    #     email: "email@email.com",
    #     name: "Jane"
    #   }
    # }
    UserAuthEmailJob.perform_async(params)
  end
end
