DB = Sequel.connect(ENV["APP_ENV"] == "test" ? ENV["TEST_DATABASE_URL"] : ENV["DATABASE_URL"], max_connections: Integer(ENV.fetch('MAX_THREADS', 5)) + 1)
DB.extension :pg_array, :pg_json, :pagination
DB.loggers << $logger
DB.sql_log_level = :debug

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :defaults_setter
Sequel::Model.plugin :basic_pg_search
Sequel::Model.plugin :first_or_initialize
Sequel::Model.plugin :sortable_by_column
