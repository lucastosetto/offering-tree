module Entities
  class PaymentEntity
    attr_reader :amount

    def initialize(amount:)
      raise TypeError, "Amount must be numeric" unless amount.is_a?(Numeric)
      raise ArgumentError, "Amount must be positive" if amount < 0

      @amount = amount
    end
  end
end
