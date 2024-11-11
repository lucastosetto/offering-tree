module UseCases
  module Errors
    class PayRateCreationFailed < StandardError
      attr_reader :errors

      def initialize(errors = [])
        @errors = errors
        super('Pay rate creation failed')
      end
    end
  end
end
