require "fast_helper"
require "null_logger"

RSpec.describe NullLogger do
  it "behaves like a logger" do
    expect(subject.info("Some log message")).to be(true)
  end
end
