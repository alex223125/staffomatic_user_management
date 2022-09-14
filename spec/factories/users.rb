FactoryBot.define do
  factory :user do
    email { "test_email@test.com" }
    is_archived  { true }
    password { "12345" }
  end
end