FactoryBot.define do
  factory :user do
    full_name { "Test User" }
    sequence(:id) { |n| n }
  end
end
