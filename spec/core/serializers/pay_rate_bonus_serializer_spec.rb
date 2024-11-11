require 'rails_helper'

RSpec.describe Serializers::PayRateBonusSerializer do
  describe '.serialize' do
    it 'serializes pay rate bonus data correctly' do
      pay_rate_bonus = double(
        'pay_rate_bonus',
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      )

      result = described_class.serialize(pay_rate_bonus)

      expect(result).to eq({
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      })
    end
  end
end