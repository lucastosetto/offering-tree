require 'rails_helper'

RSpec.describe Serializers::PayRateSerializer do
  describe '.serialize' do
    context 'when pay rate has a bonus' do
      it 'serializes pay rate data with bonus' do
        bonus = double('bonus')
        pay_rate = double(
          'pay_rate',
          id: 1,
          rate_name: 'Standard Rate',
          base_rate_per_client: 20.0,
          bonus: bonus
        )

        serialized_bonus = { id: 2, rate_per_client: 5.0, min_client_count: 3, max_client_count: 8 }
        allow(Serializers::PayRateBonusSerializer).to receive(:serialize).with(bonus).and_return(serialized_bonus)

        result = described_class.serialize(pay_rate)

        expect(result).to eq({
          id: 1,
          rate_name: 'Standard Rate',
          base_rate_per_client: 20.0,
          bonus: serialized_bonus
        })
      end
    end

    context 'when pay rate has no bonus' do
      it 'serializes pay rate data without bonus' do
        pay_rate = double(
          'pay_rate',
          id: 1,
          rate_name: 'Basic Rate',
          base_rate_per_client: 15.0,
          bonus: nil
        )

        result = described_class.serialize(pay_rate)

        expect(result).to eq({
          id: 1,
          rate_name: 'Basic Rate',
          base_rate_per_client: 15.0,
          bonus: nil
        })
      end
    end
  end
end