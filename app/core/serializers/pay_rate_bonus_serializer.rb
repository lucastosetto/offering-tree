module Serializers
  class PayRateBonusSerializer
    class << self

      def serialize(pay_rate_bonus)
        {
          id: pay_rate_bonus.id,
          rate_per_client: pay_rate_bonus.rate_per_client,
          min_client_count: pay_rate_bonus.min_client_count,
          max_client_count: pay_rate_bonus.max_client_count
        }
      end

    end
  end
end
