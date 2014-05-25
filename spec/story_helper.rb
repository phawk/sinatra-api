require_relative "spec_helper"

require 'rack/test'

# Load the story helpers
require_relative "support/story_helpers.rb"

class StoryTest < UnitTest
  include Rack::Test::Methods
  include Warden::Test::Helpers
  include StoryHelpers

  Warden.test_mode!

  register_spec_type(/Story$/, self)

  after do
    Warden.test_reset! # Reset warden auth
  end

  def app
    Api::Base
  end
end
