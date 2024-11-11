module V1
  class PayRatesController < ApplicationController
    rescue_from UseCases::Errors::PayRateCreationFailed, with: :render_unprocessable_entity
    rescue_from UseCases::Errors::PayRateUpdateFailed, with: :render_unprocessable_entity
    rescue_from TypeError, with: :render_unprocessable_entity
    rescue_from ArgumentError, with: :render_unprocessable_entity

    def create
      create_use_case = UseCases::CreatePayRate.new(pay_rate_repository)
      pay_rate = create_use_case.execute(params: pay_rate_params)

      render json: Serializers::PayRateSerializer.serialize(pay_rate), status: :created
    end

    def update
      update_use_case = UseCases::UpdatePayRate.new(pay_rate_repository)
      pay_rate = update_use_case.execute(id: params[:id], params: pay_rate_params)

      render json: Serializers::PayRateSerializer.serialize(pay_rate)
    end

    def payment
      payment_use_case = UseCases::CalculatePayment.new(pay_rate_repository)
      payment = payment_use_case.execute(pay_rate_id: params[:id], client_count: params[:clients].to_i)

      render json: Serializers::PaymentSerializer.serialize(payment)
    end

    private

    def pay_rate_repository
      @pay_rate_repository ||= begin
        bonus_repository = Repositories::PayRateBonusRepository.new
        Repositories::PayRateRepository.new(bonus_repository)
      end
    end

    def pay_rate_params
      params.permit(
        :rate_name,
        :base_rate_per_client,
        bonus: [:id, :rate_per_client, :min_client_count, :max_client_count]
      )
    end
  end
end
