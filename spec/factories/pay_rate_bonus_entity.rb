FactoryBot.define do
  factory :pay_rate_bonus_entity, class: 'Entities::PayRateBonusEntity' do
    sequence(:id) { |n| n }
    rate_per_client { 150.0 }
    min_client_count { 5 }
    max_client_count { 10 }

    initialize_with do
      new(
        id: id,
        rate_per_client: rate_per_client,
        min_client_count: min_client_count,
        max_client_count: max_client_count
      )
    end
  end
end