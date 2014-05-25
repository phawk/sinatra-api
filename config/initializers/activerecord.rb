DATABASE_URL = ENV["RACK_ENV"] == "test" ? ENV["TEST_DATABASE_URL"] : ENV["DATABASE_URL"]

db = URI.parse(DATABASE_URL)

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8',
  :pool => ENV['DB_POOL'] || 5
)
