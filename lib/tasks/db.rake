require "sinatra/activerecord/rake"

ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.env           = ENV["APP_ENV"] || "development"
  config.fixtures_path = "spec/fixtures"
end

namespace :db do
  task :load_config do
    require_relative "../../config/boot"
  end
end
