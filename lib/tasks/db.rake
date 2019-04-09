require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require_relative "../../config/boot"
  end
end
