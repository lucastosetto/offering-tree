module Entities
  class PayRateEntity
    attr_reader :id, :rate_name, :base_rate_per_client, :bonus

    def initialize(id:, rate_name:, base_rate_per_client:, bonus: nil)
      @id = id
      @rate_name = rate_name
      @base_rate_per_client = base_rate_per_client
      @bonus = bonus
    end
  end
end
