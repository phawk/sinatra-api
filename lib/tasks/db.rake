namespace :db do
  @root_dir = File.expand_path(File.join(__dir__, "..", ".."))
  require "#{@root_dir}/config/boot"
  Sequel.extension :migration

  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    if args[:version]
      Sequel::Migrator.run(DB, "db/migrations", target: args[:version].to_i)
    else
      Sequel::Migrator.run(DB, "db/migrations")
    end

    Rake::Task['db:version'].execute
  end

  desc "Rollback to migration"
  task :rollback do |t, args|
    version = if DB.tables.include?(:schema_migrations)
      previous = DB[:schema_migrations].order(Sequel.desc(:filename)).limit(2).all[1]
      previous ? previous[:filename].split("_").first : nil
    end || 0

    Sequel::Migrator.run(DB, "db/migrations", target: version.to_i)

    Rake::Task['db:version'].execute
  end

  desc "Create a migration"
  task :create_migration, [:name] do |t, args|
    require "date"
    raise("Name required") unless args[:name]

    timestamp = DateTime.now.strftime("%Y%m%d%H%M%S")
    path = "db/migrations/#{timestamp}_#{args[:name]}.rb"

    File.open("#{@root_dir}/#{path}", "w") do |f|
      f.write("Sequel.migration do\n  up do\n  end\n\n  down do\n  end\nend")
    end

    puts "MIGRATION CREATED: #{path}"
  end

  desc "Prints current schema version"
  task :version do
    version = if DB.tables.include?(:schema_migrations)
      latest = DB[:schema_migrations].order(:filename).last
      latest ? latest[:filename] : nil
    end || 0

    puts "Schema Version: #{version}"
  end
end