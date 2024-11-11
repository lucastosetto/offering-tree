module Repositories
  class PayRateRepository
    def initialize(bonus_repository: PayRateBonusRepository.new)
      @bonus_repository = bonus_repository
    end

    def find!(id)
      pay_rate = PayRate.find(id)
      bonus_entity = build_bonus_entity(pay_rate.pay_rate_bonus) if pay_rate.pay_rate_bonus
      build_entity(pay_rate, bonus_entity)
    rescue ActiveRecord::RecordNotFound
      raise Errors::RecordNotFound
    end

    def create!(params)
      ActiveRecord::Base.transaction do
        pay_rate_params = params.except(:bonus)
        pay_rate = PayRate.new(pay_rate_params)
        pay_rate.save!

        bonus_entity = create_bonus!(params[:bonus], pay_rate.id) if params[:bonus]

        build_entity(pay_rate, bonus_entity)
      end
    rescue ActiveRecord::RecordInvalid => e
      raise Errors::RecordInvalid.new(e.record.errors)
    end

    def update!(id, params)
      ActiveRecord::Base.transaction do
        pay_rate = PayRate.find(id)
        bonus_entity = update_bonus!(params[:bonus], pay_rate) if params[:bonus]

        pay_rate.update!(params.except(:bonus))
        build_entity(pay_rate, bonus_entity)
      end
    rescue ActiveRecord::RecordNotFound
      raise Errors::RecordNotFound
    rescue ActiveRecord::RecordInvalid => e
      raise Errors::RecordInvalid.new(e.record.errors)
    end

    private

    attr_reader :bonus_repository

    def create_bonus!(bonus_params, pay_rate_id)
      return nil unless bonus_params

      bonus_params = bonus_params.merge(pay_rate_id: pay_rate_id)
      bonus_repository.create!(bonus_params)
    end

    def update_bonus!(bonus_params, pay_rate)
      return nil unless bonus_params

      if pay_rate.pay_rate_bonus
        bonus_repository.update!(pay_rate.pay_rate_bonus.id, bonus_params)
      else
        create_bonus!(bonus_params, pay_rate.id)
      end
    end

    def build_entity(pay_rate, bonus_entity = nil)
      Entities::PayRateEntity.new(
        id: pay_rate.id,
        rate_name: pay_rate.rate_name,
        base_rate_per_client: pay_rate.base_rate_per_client,
        bonus: bonus_entity
      )
    end

    def build_bonus_entity(bonus)
      return nil unless bonus

      Entities::PayRateBonusEntity.new(
        id: bonus.id,
        rate_per_client: bonus.rate_per_client,
        min_client_count: bonus.min_client_count,
        max_client_count: bonus.max_client_count
      )
    end
  end
end
