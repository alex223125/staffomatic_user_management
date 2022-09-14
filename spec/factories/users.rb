FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_email#{n}@test.com" }
    is_archived  { true }
    password { "12345" }
  end
end