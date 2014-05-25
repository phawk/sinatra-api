require './app'

# logger = ::File.open("log/main.log", "a+")
# Api::Base.use Rack::CommonLogger, logger

run Api::Base
