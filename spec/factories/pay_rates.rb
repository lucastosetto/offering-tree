FactoryBot.define do
  factory :pay_rate do
    sequence(:rate_name) { |n| "Rate #{n}" }
    base_rate_per_client { 100.0 }

    trait :with_bonus do
      after(:create) do |pay_rate|
        create(:pay_rate_bonus,
          pay_rate: pay_rate,
          rate_per_client: 150.0,
          min_client_count: 5,
          max_client_count: 10
        )
      end
    end
  end
end