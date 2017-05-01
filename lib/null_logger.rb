require "logger"

class NullLogger < Logger
  def initialize
    super("/dev/null")
  end
end
