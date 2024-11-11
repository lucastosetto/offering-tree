require 'rails_helper'

RSpec.describe UseCases::CreatePayRate do
  subject(:use_case) { described_class.new(repository) }

  let(:repository) { instance_double('PayRateRepository') }
  let(:params) { { rate: 100, currency: 'USD' } }

  describe '#execute' do
    context 'when creation is successful' do
      let(:created_pay_rate) { { id: 1, rate: 100, currency: 'USD' } }

      before do
        allow(repository).to receive(:create!).with(params).and_return(created_pay_rate)
      end

      it 'creates a new pay rate' do
        result = use_case.execute(params: params)
        expect(result).to eq(created_pay_rate)
      end
    end

    context 'when validation fails' do
      let(:error_messages) { ['Rate must be positive'] }

      before do
        allow(repository).to receive(:create!)
          .and_raise(Repositories::Errors::RecordInvalid.new(error_messages))
      end

      it 'raises PayRateCreationFailed error with validation messages' do
        expect { use_case.execute(params: params) }
          .to raise_error(UseCases::Errors::PayRateCreationFailed) { |error|
            expect(error.message).to eq('Pay rate creation failed')
            expect(error.errors).to eq(error_messages)
          }
      end
    end

    context 'when unexpected error occurs' do
      before do
        allow(repository).to receive(:create!)
          .and_raise(StandardError.new('Unexpected error'))
      end

      it 'raises PayRateCreationFailed error with generic message' do
        expect { use_case.execute(params: params) }
          .to raise_error(UseCases::Errors::PayRateCreationFailed) { |error|
            expect(error.message).to eq('Pay rate creation failed')
            expect(error.errors).to eq(['Unexpected error occurred'])
          }
      end
    end
  end
end