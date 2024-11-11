module Repositories
  module Errors
    class RecordInvalid < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("Record Invalid")
      end
    end
  end
end
