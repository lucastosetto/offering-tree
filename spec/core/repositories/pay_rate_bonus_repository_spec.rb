require 'rails_helper'

RSpec.describe Repositories::PayRateBonusRepository do
  subject(:repository) { described_class.new }

  describe '#find!' do
    context 'when record exists' do
      let(:bonus) { create(:pay_rate_bonus) }

      it 'returns bonus entity' do
        result = repository.find!(bonus.id)

        aggregate_failures do
          expect(result).to be_a(Entities::PayRateBonusEntity)
          expect(result.id).to eq(bonus.id)
          expect(result.rate_per_client).to eq(bonus.rate_per_client)
          expect(result.min_client_count).to eq(bonus.min_client_count)
          expect(result.max_client_count).to eq(bonus.max_client_count)
        end
      end
    end

    context 'when record does not exist' do
      it 'raises RecordNotFound error' do
        expect { repository.find!(0) }
          .to raise_error(Repositories::Errors::RecordNotFound)
      end
    end
  end

  describe '#create!' do
    let(:pay_rate) { create(:pay_rate) }

    context 'with valid params' do
      let(:valid_params) do
        {
          pay_rate_id: pay_rate.id,
          rate_per_client: 15.0,
          min_client_count: 3,
          max_client_count: 8
        }
      end

      it 'creates and returns bonus entity' do
        result = repository.create!(valid_params)

        aggregate_failures do
          expect(result).to be_a(Entities::PayRateBonusEntity)
          expect(result.rate_per_client).to eq(valid_params[:rate_per_client])
          expect(result.min_client_count).to eq(valid_params[:min_client_count])
          expect(result.max_client_count).to eq(valid_params[:max_client_count])
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          pay_rate_id: pay_rate.id,
          rate_per_client: nil,
          min_client_count: -1,
          max_client_count: 8
        }
      end

      it 'raises RecordInvalid error' do
        expect { repository.create!(invalid_params) }
          .to raise_error(Repositories::Errors::RecordInvalid)
      end
    end
  end

  describe '#update!' do
    let(:bonus) { create(:pay_rate_bonus) }

    context 'when record exists' do
      let(:valid_params) do
        {
          rate_per_client: 25.0,
          min_client_count: 5
        }
      end

      it 'updates and returns bonus entity' do
        result = repository.update!(bonus.id, valid_params)

        aggregate_failures do
          expect(result).to be_a(Entities::PayRateBonusEntity)
          expect(result.id).to eq(bonus.id)
          expect(result.rate_per_client).to eq(valid_params[:rate_per_client])
          expect(result.min_client_count).to eq(valid_params[:min_client_count])
          expect(result.max_client_count).to eq(bonus.max_client_count)
        end
      end
    end

    context 'when record does not exist' do
      it 'raises RecordNotFound error' do
        expect { repository.update!(0, { rate_per_client: 20.0 }) }
          .to raise_error(Repositories::Errors::RecordNotFound)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          rate_per_client: nil,
          min_client_count: -1
        }
      end

      it 'raises RecordInvalid error' do
        expect { repository.update!(bonus.id, invalid_params) }
          .to raise_error(Repositories::Errors::RecordInvalid)
      end
    end
  end
end