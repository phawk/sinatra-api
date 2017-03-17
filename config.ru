require './app'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any, max_age: 2592000 # 30 days
  end
end

run Api::Base
