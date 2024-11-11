module Serializers
  class PayRateSerializer
    class << self

      def serialize(pay_rate)
        bonus = PayRateBonusSerializer.serialize(pay_rate.bonus) if pay_rate.bonus

        {
          id: pay_rate.id,
          rate_name: pay_rate.rate_name,
          base_rate_per_client: pay_rate.base_rate_per_client,
          bonus: bonus
        }
      end

    end
  end
end
