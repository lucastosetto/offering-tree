class PayRateBonus < ApplicationRecord
  self.table_name = 'pay_rate_bonuses'

  belongs_to :pay_rate

  validates :rate_per_client, presence: true, numericality: { greater_than: 0 }
  validates :min_client_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_client_count, presence: true, numericality: { only_integer: true, greater_than: :min_client_count }
end