module Repositories
  class PayRateBonusRepository
    def find!(id)
      bonus = PayRateBonus.find(id)
      build_entity(bonus)
    rescue ActiveRecord::RecordNotFound
      raise Errors::RecordNotFound
    end

    def create!(params)
      bonus = PayRateBonus.create!(params)
      build_entity(bonus)
    rescue ActiveRecord::RecordInvalid => e
      raise Errors::RecordInvalid.new(e.record.errors)
    end

    def update!(id, params)
      bonus = PayRateBonus.find(id)
      bonus.update!(params)
      build_entity(bonus)
    rescue ActiveRecord::RecordNotFound
      raise Errors::RecordNotFound
    rescue ActiveRecord::RecordInvalid => e
      raise Errors::RecordInvalid.new(e.record.errors)
    end

    private

    def build_entity(bonus)
      Entities::PayRateBonusEntity.new(
        id: bonus.id,
        rate_per_client: bonus.rate_per_client,
        min_client_count: bonus.min_client_count,
        max_client_count: bonus.max_client_count
      )
    end
  end
end