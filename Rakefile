require "sinatra/activerecord/rake"

Dir.glob('lib/tasks/*.rake').each { |r| import r }

task :load_environment do
  require "./config/boot"
end

# Filthy hack, need a better way...
# Rake.application.in_namespace(:db) { |x| p x.tasks.map(&:needed?) }
['db:create', 'db:create_migration', 'db:drop', 'db:fixtures:load', 'db:migrate', 'db:migrate:status', 'db:rollback', 'db:schema:cache:clear', 'db:schema:cache:dump', 'db:schema:dump', 'db:schema:load', 'db:seed', 'db:setup', 'db:structure:dump', 'db:version'].each do |name|
  task name => :load_environment
end

task default: :spec
