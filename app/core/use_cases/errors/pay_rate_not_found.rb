module UseCases
  module Errors
    class PayRateNotFound < StandardError
      def initialize
        super('Pay rate not found')
      end
    end
  end
end
