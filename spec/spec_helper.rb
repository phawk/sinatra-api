# TEST ENV VARS
ENV["APP_ENV"] = "test"

require "fast_helper"
require "bundler"
Bundler.require :default, :test

# Load the application
require_relative "../config/boot"
require "sidekiq/testing"

# Load the unit helpers
require_relative "support/api_helper"
require_relative "support/mail_helper"
require_relative "support/file_helper"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.before(:suite) do
    # Set mail into test mode
    Mail.defaults do
      delivery_method :test
    end
  end

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
