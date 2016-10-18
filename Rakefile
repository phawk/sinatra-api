require "sinatra/activerecord/rake"

Dir.glob('lib/tasks/*.rake').each { |r| import r }

namespace :db do
  task :load_config do
    require "./app"
  end
end

task default: :spec
