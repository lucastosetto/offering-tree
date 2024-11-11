require 'rails_helper'

RSpec.describe PayRateBonus, type: :model do
  describe 'associations' do
    it 'belongs to pay rate' do
      association = described_class.reflect_on_association(:pay_rate)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    context 'when rate_per_client is empty' do
      it 'is invalid' do
        bonus = build(:pay_rate_bonus, rate_per_client: nil)
        bonus.valid?
        expect(bonus.errors[:rate_per_client]).to include("can't be blank")
      end
    end

    context 'when rate_per_client is zero or negative' do
      it 'is invalid' do
        bonus = build(:pay_rate_bonus, rate_per_client: 0)
        bonus.valid?
        expect(bonus.errors[:rate_per_client]).to include('must be greater than 0')
      end
    end

    context 'when min_client_count is negative' do
      it 'is invalid' do
        bonus = build(:pay_rate_bonus, min_client_count: -1)
        bonus.valid?
        expect(bonus.errors[:min_client_count]).to include('must be greater than or equal to 0')
      end
    end

    context 'when max_client_count is less than min_client_count' do
      it 'is invalid' do
        min_client_count = 5
        bonus = build(:pay_rate_bonus, min_client_count: min_client_count, max_client_count: 4)
        bonus.valid?
        expect(bonus.errors[:max_client_count]).to include("must be greater than #{min_client_count}")
      end
    end

    context 'when max_client_count equals min_client_count' do
      it 'is invalid' do
        min_client_count = 5
        bonus = build(:pay_rate_bonus, min_client_count: min_client_count, max_client_count: 5)
        bonus.valid?
        expect(bonus.errors[:max_client_count]).to include("must be greater than #{min_client_count}")
      end
    end
  end
end