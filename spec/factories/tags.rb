FactoryBot.define do
  factory :tag do
    tag { "test "}
    association :user
  end
end