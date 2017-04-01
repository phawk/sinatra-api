DB = Sequel.connect(ENV["RACK_ENV"] == "test" ? ENV["TEST_DATABASE_URL"] : ENV["DATABASE_URL"], max_connections: Integer(ENV['MAX_THREADS']) + 1)
DB.extension :pg_array, :pg_json, :pagination

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers