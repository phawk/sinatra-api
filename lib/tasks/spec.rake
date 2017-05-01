desc "Run all tests"
task(:spec) do
  Dir["./spec/**/*_spec.rb"].each { |f| load f }
end

namespace(:spec) do
  desc "Run only fast tests"
  task :fast do
    Dir["./spec/lib/**/*_spec.rb"].each { |f| load f }
  end

  desc "Run only unit tests"
  task :units do
    Dir["./spec/unit/**/*_spec.rb"].each { |f| load f }
  end

  desc "Run only story tests"
  task :stories do
    Dir["./spec/stories/**/*_spec.rb"].each { |f| load f }
  end
end
