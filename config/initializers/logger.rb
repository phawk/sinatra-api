require 'logger'

$logger = begin
  case ENV['RACK_ENV']
  when "test"
    Logger.new("/dev/null")
  else
    # Log to a file
    # Logger.new(File.expand_path(File.join(__dir__, "..", "..", "log", ENV.fetch('RACK_ENV', 'development')+".log")))

    # Log to STDOUT
    Logger.new(STDOUT)
  end
end
