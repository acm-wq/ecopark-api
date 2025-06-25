FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
