require 'rails_helper'

module Entities
  RSpec.describe PayRateEntity do
    describe '#initialize' do
      context 'when all required attributes are provided' do
        subject(:pay_rate) { described_class.new(**pay_rate_attributes) }

        let(:pay_rate_attributes) do
          {
            id: 1,
            rate_name: 'Standard Rate',
            base_rate_per_client: 100.0
          }
        end

        it 'creates a pay rate entity with the given attributes' do
          expect(pay_rate.id).to eq(pay_rate_attributes[:id])
          expect(pay_rate.rate_name).to eq(pay_rate_attributes[:rate_name])
          expect(pay_rate.base_rate_per_client).to eq(pay_rate_attributes[:base_rate_per_client])
          expect(pay_rate.bonus).to be_nil
        end
      end

      context 'when bonus is provided' do
        subject(:pay_rate) { described_class.new(**pay_rate_attributes) }

        let(:pay_rate_attributes) do
          {
            id: 1,
            rate_name: 'Premium Rate',
            base_rate_per_client: 150.0,
            bonus: 50.0
          }
        end

        it 'creates a pay rate entity with bonus' do
          expect(pay_rate.id).to eq(pay_rate_attributes[:id])
          expect(pay_rate.rate_name).to eq(pay_rate_attributes[:rate_name])
          expect(pay_rate.base_rate_per_client).to eq(pay_rate_attributes[:base_rate_per_client])
          expect(pay_rate.bonus).to eq(pay_rate_attributes[:bonus])
        end
      end

      context 'when required attributes are missing' do
        it 'raises an ArgumentError when id is missing' do
          expect {
            described_class.new(rate_name: 'Standard Rate', base_rate_per_client: 100.0)
          }.to raise_error(ArgumentError, /missing keyword: :?id/i)
        end

        it 'raises an ArgumentError when rate_name is missing' do
          expect {
            described_class.new(id: 1, base_rate_per_client: 100.0)
          }.to raise_error(ArgumentError, /missing keyword: :?rate_name/i)
        end

        it 'raises an ArgumentError when base_rate_per_client is missing' do
          expect {
            described_class.new(id: 1, rate_name: 'Standard Rate')
          }.to raise_error(ArgumentError, /missing keyword: :?base_rate_per_client/i)
        end
      end
    end
  end
end