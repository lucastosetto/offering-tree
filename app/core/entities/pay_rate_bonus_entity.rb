module Entities
  class PayRateBonusEntity
    attr_reader :id, :rate_per_client, :min_client_count, :max_client_count

    def initialize(id:, rate_per_client:, min_client_count:, max_client_count:)
      @id = id
      @rate_per_client = rate_per_client
      @min_client_count = min_client_count
      @max_client_count = max_client_count
    end

    def ==(other)
      return false unless other.is_a?(self.class)

      id == other.id &&
        rate_per_client == other.rate_per_client &&
        min_client_count == other.min_client_count &&
        max_client_count == other.max_client_count
    end
    alias eql? ==

    def hash
      [self.class, id, rate_per_client, min_client_count, max_client_count].hash
    end
  end
end
