require 'rails_helper'

RSpec.describe PayRate do
  describe 'associations' do
    it 'has one pay rate bonus' do
      association = described_class.reflect_on_association(:pay_rate_bonus)

      expect(association.macro).to eq :has_one
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    let(:pay_rate) { build(:pay_rate) }

    context 'rate_name' do
      it 'requires presence' do
        pay_rate.rate_name = nil
        pay_rate.valid?
        expect(pay_rate.errors[:rate_name]).to include("can't be blank")
      end
    end

    context 'base_rate_per_client' do
      it 'requires presence' do
        pay_rate.base_rate_per_client = nil
        pay_rate.valid?
        expect(pay_rate.errors[:base_rate_per_client]).to include("can't be blank")
      end

      it 'must be greater than 0' do
        pay_rate.base_rate_per_client = 0
        pay_rate.valid?
        expect(pay_rate.errors[:base_rate_per_client]).to include("must be greater than 0.0")
      end

      it 'accepts valid values' do
        pay_rate.base_rate_per_client = 100
        expect(pay_rate).to be_valid
      end
    end
  end
end