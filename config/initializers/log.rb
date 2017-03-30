require 'logger'

# Log to a file
# $log = Logger.new(File.expand_path(File.join(__dir__, "..", "..", "log", ENV.fetch('RACK_ENV', 'development')+".log")))

# Log to STDOUT
$log = Logger.new(STDOUT)
