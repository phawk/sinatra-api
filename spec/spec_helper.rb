# TEST ENV VARS
ENV["RACK_ENV"] = "test"
ENV["API_SESSION_SECRET"] = "test_session_secret"
ENV["JWT_SECRET_KEY"] = "a4e4059226487d2585db838c802c4ea5606daad24fe3ff351f66dd860a77a90d"

require 'bundler'
Bundler.require :default, :test

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/rg'
require 'mocha/mini_test'
require 'pp'


# Load the application
require_relative '../app'

# Grab the factories
FactoryGirl.find_definitions

# Set mail into test mode
Mail.defaults do
  delivery_method :test
end

# Load the unit helpers
require_relative "support/unit_helpers.rb"


class UnitTest < MiniTest::Spec
  include FactoryGirl::Syntax::Methods
  include UnitHelpers


  # Run tests in a transaction
  def run( *args, &block )
    value = nil

    begin
      ActiveRecord::Base.connection.transaction do
        value = super
        raise ActiveRecord::Rollback
      end
    rescue ActiveRecord::Rollback
    end

    return value  # The result of run must be always returned for the pretty dots to show up
  end

  register_spec_type(/(Unit|Spec|Model)$/, self)

  register_spec_type(self) do |desc|
    true if desc.is_a?(Class)
  end
end
