require "faker"
require "securerandom"
require "active_support/core_ext/integer/time"

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8, 20) }
  end
end
