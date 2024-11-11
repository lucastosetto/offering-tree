require 'spec_helper'

RSpec.describe Entities::PaymentEntity do
  describe '#initialize' do
    context 'when amount is numeric' do
      it 'creates payment with positive amount' do
        amount = 100.0

        payment = described_class.new(amount: amount)

        expect(payment.amount).to eq(amount)
      end

      it 'creates payment with zero amount' do
        amount = 0

        payment = described_class.new(amount: amount)

        expect(payment.amount).to eq(amount)
      end
    end

    context 'when amount is not numeric' do
      it 'raises TypeError' do
        expect {
          described_class.new(amount: 'invalid')
        }.to raise_error(TypeError, 'Amount must be numeric')
      end
    end

    context 'when amount is negative' do
      it 'raises ArgumentError' do
        expect {
          described_class.new(amount: -1)
        }.to raise_error(ArgumentError, 'Amount must be positive')
      end
    end
  end
end