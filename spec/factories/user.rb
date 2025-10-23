FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "teste123" }
    password_confirmation { "teste123" }
  end
end
