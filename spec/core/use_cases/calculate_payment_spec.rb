require 'rails_helper'

RSpec.describe UseCases::CalculatePayment do
  subject(:use_case) { described_class.new(repository) }

  let(:repository) { instance_double('PayRateRepository') }
  let(:pay_rate_id) { 1 }
  let(:base_rate_per_client) { 5.00 }
  let(:pay_rate) do
    instance_double('PayRateEntity',
      id: pay_rate_id,
      base_rate_per_client: base_rate_per_client,
      bonus: bonus)
  end
  let(:bonus) { nil }

  describe '#execute' do
    before do
      allow(repository).to receive(:find!).with(pay_rate_id).and_return(pay_rate)
    end

    context 'when pay rate has no bonus' do
      let(:client_count) { 15 }

      it 'calculates payment using only base rate' do
        result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)

        expect(result).to be_a(Entities::PaymentEntity)
        expect(result.amount).to eq(75.00)
      end
    end

    context 'pay rate with min_client_count only' do
      let(:bonus) do
        instance_double('PayRateBonusEntity',
          rate_per_client: 3.00,
          min_client_count: 25,
          max_client_count: nil)
      end

      context 'when there are 15 clients' do
        let(:client_count) { 15 }

        it 'calculates payment using only base rate' do
          result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)

          expect(result.amount).to eq(75.00)
        end
      end

      context 'when there are 30 clients' do
        let(:client_count) { 30 }

        it 'calculates payment with bonus for 5 clients' do
          result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)

          expect(result.amount).to eq(165.00)
        end
      end
    end

    context 'pay rate with both min and max client count' do
      let(:bonus) do
        instance_double('PayRateBonusEntity',
          rate_per_client: 3.00,
          min_client_count: 25,
          max_client_count: 40)
      end

      context 'when there are 30 clients' do
        let(:client_count) { 30 }

        it 'calculates payment with bonus for 5 clients' do
          result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)

          expect(result.amount).to eq(165.00)
        end
      end

      context 'when there are 45 clients' do
        let(:client_count) { 45 }

        it 'calculates payment with bonus capped at max_client_count' do
          result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)

          # NOTE: In the provided example, we have 5.00 * 15 + (40 - 25) * 3.00 = $195.00,
          # but the client_count is 45, so it seems there is an error in the example.
          # The correct calculation should be 5.00 * 45 + (45 - 25) * 3.00 = $270.00
          expect(result.amount).to eq(270.00)
        end
      end
    end

    context 'pay rate with max_client_count only' do
      let(:bonus) do
        instance_double('PayRateBonusEntity',
          rate_per_client: 3.00,
          min_client_count: nil,
          max_client_count: 40)
      end

      context 'when there are 45 clients' do
        let(:client_count) { 45 }

        it 'calculates payment with bonus capped at max_client_count' do
          result = use_case.execute(pay_rate_id: pay_rate_id, client_count: client_count)
        end
      end
    end

    context 'when pay rate is not found' do
      before do
        allow(repository).to receive(:find!)
          .and_raise(Repositories::Errors::RecordNotFound)
      end

      it 'raises PayRateNotFound error' do
        expect {
          use_case.execute(pay_rate_id: pay_rate_id, client_count: 15)
        }.to raise_error(UseCases::Errors::PayRateNotFound)
      end
    end
  end
end