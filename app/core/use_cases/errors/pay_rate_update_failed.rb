module UseCases
  module Errors
    class PayRateUpdateFailed < StandardError
      attr_reader :errors

      def initialize(errors = [])
        @errors = errors
        super('Pay rate update failed')
      end
    end
  end
end
