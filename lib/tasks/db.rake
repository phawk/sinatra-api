# rubocop:disable Metrics/BlockLength
namespace :db do
  task :environment do
    # Default ENV to dev if not present
    ENV['RACK_ENV'] ||= 'development'
    ENV['APP_ENV'] ||= ENV['RACK_ENV']

    # Autoload gems from the Gemfile
    require "bundler"
    Bundler.require :default, ENV['RACK_ENV'].to_sym

    # Load dev env vars
    Dotenv.load if %w[development test].include? ENV['RACK_ENV']
  end

  task connect_db: :environment do
    @root_dir = File.expand_path(File.join(__dir__, "..", ".."))
    require "#{@root_dir}/config/initializers/logger"
    require "#{@root_dir}/config/initializers/sequel"

    Sequel.extension :migration
  end

  desc "Create databases"
  task create: :environment do
    %w[DATABASE_URL TEST_DATABASE_URL].each do |db_url|
      db_url = ENV[db_url]
      puts "CREATE: #{db_url}"

      if db_url.nil?
        puts "#{db_url} not set!"
        next
      end

      dbname = URI.parse(db_url).path[1..-1]
      system("createdb #{dbname}")
    end
  end

  desc "Run migrations"
  task :migrate, [:version] => :connect_db do |_, args|
    if args[:version]
      Sequel::Migrator.run(DB, "db/migrations", target: args[:version].to_i)
    else
      Sequel::Migrator.run(DB, "db/migrations")
    end

    if ENV['RACK_ENV'] == "development"
      system("sequel -d #{ENV['DATABASE_URL']} > #{@root_dir}/db/schema.rb")
    end

    Rake::Task['db:version'].execute
  end

  desc "Rollback to migration"
  task rollback: :connect_db do
    version = if DB.tables.include?(:schema_migrations)
                previous = DB[:schema_migrations].order(Sequel.desc(:filename)).limit(2).all[1]
                previous ? previous[:filename].split("_").first : nil
              end || 0

    Sequel::Migrator.run(DB, "db/migrations", target: version.to_i)

    Rake::Task['db:version'].execute
  end

  desc "Create a migration"
  task :create_migration, [:name] => :connect_db do |_, args|
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
  task version: :connect_db do
    version = if DB.tables.include?(:schema_migrations)
                latest = DB[:schema_migrations].order(:filename).last
                latest ? latest[:filename] : nil
              end || 0

    puts "Schema Version: #{version}"
  end
end
