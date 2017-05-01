DB = Sequel.connect(ENV["RACK_ENV"] == "test" ? ENV["TEST_DATABASE_URL"] : ENV["DATABASE_URL"], max_connections: Integer(ENV.fetch('MAX_THREADS', 5)) + 1)
DB.extension :pg_array, :pg_json, :pagination

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :basic_pg_search
Sequel::Model.plugin :first_or_initialize
Sequel::Model.plugin :sortable_by_column
