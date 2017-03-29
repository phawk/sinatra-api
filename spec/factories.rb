require 'faker'
require 'securerandom'

FactoryGirl.define do
  to_create { |i| i.save }

  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8, 20) }
    updated_at { 10.days.ago }
    created_at { 10.days.ago }

    factory :user_with_token do
      after(:create) do |user|
        create(:access_token, user_id: user.id)
      end
    end
  end


  factory :client_application do
    name { Faker::Name.title }
    client_id { SecureRandom.hex(32) }
    client_secret { SecureRandom.hex(32) }
    user
    updated_at { 10.days.ago }
    created_at { 10.days.ago }
  end


  factory :access_token do
    token { SecureRandom.hex(32) }
    user
    client_application
    updated_at { 10.days.ago }
    created_at { 10.days.ago }
  end

end
