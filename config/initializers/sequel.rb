DB = Sequel.connect(ENV["RACK_ENV"] == "test" ? ENV["TEST_DATABASE_URL"] : ENV["DATABASE_URL"])

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers