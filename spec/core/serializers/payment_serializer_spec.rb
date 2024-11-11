require 'rails_helper'

RSpec.describe Serializers::PaymentSerializer do
  describe '.serialize' do
    it 'serializes payment data correctly' do
      payment = double('payment')

      result = described_class.serialize(payment)

      expect(result).to eq({ payment: payment })
    end
  end
end