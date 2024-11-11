class PayRateBonus < ApplicationRecord
  self.table_name = 'pay_rate_bonuses'

  belongs_to :pay_rate

  validates :rate_per_client, presence: true, numericality: { greater_than: 0 }
  validates :min_client_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }
  validates :max_client_count, numericality: {
    only_integer: true,
    greater_than: :min_client_count,
    allow_nil: true
  }, if: :min_client_count?
  validate :at_least_one_client_count_present

  private

  def at_least_one_client_count_present
    if min_client_count.nil? && max_client_count.nil?
      errors.add(:base, 'At least one of min_client_count or max_client_count must be present')
    end
  end
end