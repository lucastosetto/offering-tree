require 'rails_helper'

RSpec.describe Repositories::PayRateRepository do
  let(:bonus_repository) { instance_double(Repositories::PayRateBonusRepository) }
  let(:repository) { described_class.new(bonus_repository) }

  describe '#find!' do
    context 'when record exists' do
      let(:pay_rate) { create(:pay_rate) }

      it 'returns pay rate entity' do
        result = repository.find!(pay_rate.id)

        aggregate_failures do
          expect(result).to be_a(Entities::PayRateEntity)
          expect(result.id).to eq(pay_rate.id)
          expect(result.rate_name).to eq(pay_rate.rate_name)
          expect(result.base_rate_per_client).to eq(pay_rate.base_rate_per_client)
        end
      end

      context 'when pay rate has bonus' do
        let!(:bonus) { create(:pay_rate_bonus, pay_rate: pay_rate) }

        it 'includes bonus entity' do
          result = repository.find!(pay_rate.id)

          aggregate_failures do
            expect(result.bonus).to be_a(Entities::PayRateBonusEntity)
            expect(result.bonus.id).to eq(bonus.id)
            expect(result.bonus.rate_per_client).to eq(bonus.rate_per_client)
            expect(result.bonus.min_client_count).to eq(bonus.min_client_count)
            expect(result.bonus.max_client_count).to eq(bonus.max_client_count)
          end
        end
      end
    end

    context 'when record does not exist' do
      it 'raises RecordNotFound error' do
        expect { repository.find!(0) }.to raise_error(Repositories::Errors::RecordNotFound)
      end
    end
  end

  describe '#create!' do
    let(:valid_params) do
      {
        rate_name: 'New Rate',
        base_rate_per_client: 150.0
      }
    end

    context 'with valid params' do
      it 'creates and returns pay rate entity' do
        result = repository.create!(valid_params)

        aggregate_failures do
          expect(result).to be_a(Entities::PayRateEntity)
          expect(result.rate_name).to eq(valid_params[:rate_name])
          expect(result.base_rate_per_client).to eq(valid_params[:base_rate_per_client])
        end
      end

      context 'with bonus params' do
        let(:pay_rate_params) do
          valid_params.merge(
            bonus: {
              rate_per_client: 20.0,
              min_client_count: 3,
              max_client_count: 8
            }
          )
        end

        it 'creates pay rate with bonus' do
          pay_rate = create(:pay_rate)
          bonus_entity = build(:pay_rate_bonus_entity)

          expect(PayRate).to receive(:new).and_return(pay_rate)
          expect(pay_rate).to receive(:save!)
          expect(bonus_repository).to receive(:create!)
            .with(pay_rate_params[:bonus].merge(pay_rate_id: pay_rate.id))
            .and_return(bonus_entity)

          result = repository.create!(pay_rate_params)

          expect(result).to be_a(Entities::PayRateEntity)
          expect(result.bonus).to eq(bonus_entity)
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { rate_name: nil } }

      it 'raises RecordInvalid error' do
        expect { repository.create!(invalid_params) }
          .to raise_error(Repositories::Errors::RecordInvalid)
      end
    end
  end

  describe '#update!' do
    let(:pay_rate) { create(:pay_rate) }
    let(:bonus_repository) { instance_double('Repositories::PayRateBonusRepository') }
    let(:repository) { described_class.new(bonus_repository) }

    context 'when pay rate does not exist' do
      it 'raises RecordNotFound error' do
        expect { repository.update!(0, {}) }
          .to raise_error(Repositories::Errors::RecordNotFound)
      end
    end

    context 'when update fails validation' do
      let(:invalid_params) { { rate_name: '' } }

      it 'raises RecordInvalid error' do
        expect { repository.update!(pay_rate.id, invalid_params) }
          .to raise_error(Repositories::Errors::RecordInvalid)
      end
    end

    context 'when updating with bonus' do
      let(:bonus_params) { { rate_per_client: 150.0 } }
      let(:params) { { rate_name: 'Updated Rate', bonus: bonus_params } }

      context 'when pay rate has no existing bonus' do
        before do
          allow(bonus_repository).to receive(:create!)
            .with(hash_including(bonus_params))
            .and_return(build(:pay_rate_bonus_entity))
        end

        it 'creates new bonus' do
          repository.update!(pay_rate.id, params)
          expect(bonus_repository).to have_received(:create!)
        end
      end

      context 'when pay rate has existing bonus' do
        let!(:existing_bonus) { create(:pay_rate_bonus, pay_rate: pay_rate) }

        before do
          allow(bonus_repository).to receive(:update!)
            .with(existing_bonus.id, bonus_params)
            .and_return(build(:pay_rate_bonus_entity))
        end

        it 'updates existing bonus' do
          repository.update!(pay_rate.id, params)
          expect(bonus_repository).to have_received(:update!)
        end
      end
    end
  end
end