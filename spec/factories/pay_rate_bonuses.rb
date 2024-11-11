FactoryBot.define do
  factory :pay_rate_bonus do
    rate_per_client { 150.0 }
    min_client_count { 5 }
    max_client_count { 10 }
    association :pay_rate
  end
end