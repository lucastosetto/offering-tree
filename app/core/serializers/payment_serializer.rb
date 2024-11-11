module Serializers
  class PaymentSerializer
    class << self

      def serialize(payment)
        {
          payment: payment
        }
      end

    end
  end
end
