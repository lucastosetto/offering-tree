FactoryBot.define do
  factory :pay_rate_bonus do
    rate_per_client { 150.0 }
    min_client_count { 5 }
    max_client_count { 10 }
    association :pay_rate

    trait :with_min_only do
      max_client_count { nil }
    end

    trait :with_max_only do
      min_client_count { nil }
    end
  end
end