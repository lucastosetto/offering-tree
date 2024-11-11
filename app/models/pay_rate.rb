class PayRate < ApplicationRecord
  has_one :pay_rate_bonus, dependent: :destroy

  validates :rate_name, presence: true
  validates :base_rate_per_client, presence: true, numericality: { greater_than: 0.0 }
end