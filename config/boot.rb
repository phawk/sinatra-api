# Add current path and lib to the load path
$: << File.expand_path("../../", __FILE__)
$: << File.expand_path("../../lib", __FILE__)

# Default ENV to dev if not present
ENV["APP_ENV"] ||= "development"

# Autoload common standard library features
require "json"

# Autoload gems from the Gemfile
require "bundler"
Bundler.require :default, ENV["APP_ENV"].to_sym

# Load dev env vars
Dotenv.load if %w[development test].include? ENV["APP_ENV"]

# Autoload app dependencies
(Dir['./config/initializers/*.rb'].sort +
 Dir['./app/helpers/**/*.rb'].sort +
 Dir['./app/mailers/**/*.rb'].sort +
 Dir['./app/models/sequel_model.rb'].sort +
 Dir['./app/models/**/*.rb'].sort +
 Dir['./app/jobs/**/*.rb'].sort +
 Dir['./app/serializers/base_serializer.rb'].sort +
 Dir['./app/serializers/**/*.rb'].sort +
 Dir['./app/routes/base.rb'].sort +
 Dir['./app/routes/**/*.rb'].sort
).uniq.each { |rb| require rb }
