# Add current path and lib to the load path
$: << File.expand_path('../../', __FILE__)
$: << File.expand_path('../../lib', __FILE__)

# Default ENV to dev if not present
ENV['RACK_ENV'] ||= 'development'
ENV['APP_ENV'] ||= ENV['RACK_ENV']

# Autoload gems from the Gemfile
require "bundler"
Bundler.require :default, ENV['RACK_ENV'].to_sym

# Load dev env vars
Dotenv.load if ["development", "test"].include? ENV['RACK_ENV']

# Autoload app dependencies
(Dir['./config/initializers/*.rb'].sort +
 Dir['./app/helpers/**/*.rb'].sort +
 Dir['./app/mailers/**/*.rb'].sort +
 Dir['./app/validators/**/*.rb'].sort +
 Dir['./app/models/base_model.rb'].sort +
 Dir['./app/models/**/*.rb'].sort +
 Dir['./app/jobs/**/*.rb'].sort +
 Dir['./app/serializers/base_serializer.rb'].sort +
 Dir['./app/serializers/**/*.rb'].sort
).uniq.each { |rb| require rb }
