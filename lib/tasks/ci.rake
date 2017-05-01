begin
  require "bundler/audit/task"
  require "rspec/core/rake_task"
  require "rubocop/rake_task"

  Bundler::Audit::Task.new
  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new

  namespace :ci do
    task :all do
      Rake::Task["rubocop"].invoke
      Rake::Task["spec"].invoke
      Rake::Task["bundle:audit"].invoke
    end
  end
rescue LoadError
  puts "Can’t load CI task"
end
