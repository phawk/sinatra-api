require "logger"
require "null_logger"

$logger = begin
  case ENV["APP_ENV"]
  when "test"
    NullLogger.new
  else
    # Log to a file
    # Logger.new(File.expand_path(File.join(__dir__, "..", "..", "log", ENV.fetch('APP_ENV', 'development')+".log")))

    # Log to STDOUT
    Logger.new(STDOUT)
  end
end

$logger.level = begin
  case String(ENV["LOG_LEVEL"]).downcase
  when "info"
    Logger::INFO
  when "warn"
    Logger::WARN
  when "error"
    Logger::ERROR
  else
    Logger::DEBUG
  end
end
