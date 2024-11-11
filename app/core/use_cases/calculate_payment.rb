module UseCases
  class CalculatePayment

    def initialize(repository)
      @repository = repository
    end

    def execute(pay_rate_id:, client_count:)
      pay_rate = @repository.find!(pay_rate_id)

      base_payment = calculate_base_payment(pay_rate.base_rate_per_client, client_count)
      bonus_payment = calculate_bonus_payment(client_count, pay_rate.bonus)

      total_payment = base_payment + bonus_payment

      Entities::PaymentEntity.new(amount: total_payment)
    rescue Repositories::Errors::RecordNotFound
      raise Errors::PayRateNotFound
    end

    private

    def calculate_base_payment(base_rate_per_client, client_count)
      base_rate_per_client * client_count
    end

    def calculate_bonus_payment(client_count, pay_rate_bonus)
      return 0.0 unless pay_rate_bonus

      min_client_count = pay_rate_bonus.min_client_count.to_f
      max_client_count = pay_rate_bonus.max_client_count || Float::INFINITY

      return 0.0 if client_count < min_client_count

      bonus_eligible_clients = [client_count, max_client_count].min - min_client_count
      bonus_eligible_clients * pay_rate_bonus.rate_per_client
    end

  end
end