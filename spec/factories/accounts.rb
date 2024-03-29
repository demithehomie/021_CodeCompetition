FactoryBot.define do
  factory :account do
    currency { "USD" }
    balance { 0.0 }
    association :user    
  end
end
