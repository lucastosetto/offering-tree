require 'rails_helper'

RSpec.describe Entities::PayRateBonusEntity do
  describe '#initialize' do
    subject(:entity) do
      described_class.new(
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      )
    end

    it 'sets all attributes correctly' do
      aggregate_failures do
        expect(entity.id).to eq(1)
        expect(entity.rate_per_client).to eq(10.0)
        expect(entity.min_client_count).to eq(5)
        expect(entity.max_client_count).to eq(10)
      end
    end
  end

  describe '#==' do
    let(:entity1) do
      described_class.new(
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      )
    end

    context 'when comparing with identical entity' do
      let(:entity2) do
        described_class.new(
          id: 1,
          rate_per_client: 10.0,
          min_client_count: 5,
          max_client_count: 10
        )
      end

      it 'returns true' do
        expect(entity1).to eq(entity2)
      end
    end

    context 'when comparing with different entity' do
      let(:entity2) do
        described_class.new(
          id: 1,
          rate_per_client: 20.0,
          min_client_count: 5,
          max_client_count: 10
        )
      end

      it 'returns false' do
        expect(entity1).not_to eq(entity2)
      end
    end

    context 'when comparing with different class' do
      let(:other_object) { Object.new }

      it 'returns false' do
        expect(entity1).not_to eq(other_object)
      end
    end
  end

  describe '#hash' do
    let(:entity1) do
      described_class.new(
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      )
    end

    let(:entity2) do
      described_class.new(
        id: 1,
        rate_per_client: 10.0,
        min_client_count: 5,
        max_client_count: 10
      )
    end

    it 'returns same hash for equal entities' do
      expect(entity1.hash).to eq(entity2.hash)
    end

    it 'can be used as hash key' do
      hash = { entity1 => 'value' }
      expect(hash[entity2]).to eq('value')
    end
  end
end