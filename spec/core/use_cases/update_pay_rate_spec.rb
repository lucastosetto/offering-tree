require 'rails_helper'

RSpec.describe UseCases::UpdatePayRate do
  subject(:use_case) { described_class.new(repository) }

  let(:repository) { instance_double('PayRateRepository') }
  let(:pay_rate_id) { 1 }
  let(:params) { { rate: 150, currency: 'USD' } }

  describe '#execute' do
    context 'when update is successful' do
      let(:updated_pay_rate) { { id: pay_rate_id, rate: 150, currency: 'USD' } }

      before do
        allow(repository).to receive(:update!)
          .with(pay_rate_id, params)
          .and_return(updated_pay_rate)
      end

      it 'updates the pay rate' do
        result = use_case.execute(id: pay_rate_id, params: params)
        expect(result).to eq(updated_pay_rate)
      end
    end

    context 'when pay rate is not found' do
      before do
        allow(repository).to receive(:update!)
          .and_raise(Repositories::Errors::RecordNotFound)
      end

      it 'raises PayRateNotFound error' do
        expect { use_case.execute(id: pay_rate_id, params: params) }
          .to raise_error(UseCases::Errors::PayRateNotFound)
      end
    end

    context 'when validation fails' do
      let(:error_messages) { ['Rate must be positive'] }

      before do
        allow(repository).to receive(:update!)
          .and_raise(Repositories::Errors::RecordInvalid.new(error_messages))
      end

      it 'raises PayRateUpdateFailed error with validation messages' do
        expect { use_case.execute(id: pay_rate_id, params: params) }
          .to raise_error(UseCases::Errors::PayRateUpdateFailed) { |error|
            expect(error.message).to eq('Pay rate update failed')
            expect(error.errors).to eq(error_messages)
          }
      end
    end

    context 'when unexpected error occurs' do
      before do
        allow(repository).to receive(:update!)
          .and_raise(StandardError.new('Unexpected error'))
      end

      it 'raises PayRateUpdateFailed error with generic message' do
        expect { use_case.execute(id: pay_rate_id, params: params) }
          .to raise_error(UseCases::Errors::PayRateUpdateFailed) { |error|
            expect(error.message).to eq('Pay rate update failed')
            expect(error.errors).to eq(['Unexpected error occurred'])
          }
      end
    end
  end
end