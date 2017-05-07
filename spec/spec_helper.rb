# TEST ENV VARS
ENV["RACK_ENV"] = "test"

require "fast_helper"
require "bundler"
Bundler.require :default, :test

# Load the application
require_relative "../config/boot"

require "sidekiq/testing"

# Grab the factories
FactoryGirl.find_definitions

# Load the unit helpers
require_relative "support/api_helper"
require_relative "support/mail_helper"
require_relative "support/token_helper"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

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
    DB.transaction(rollback: :always, auto_savepoint: true) do
      example.run
    end
  end
end
