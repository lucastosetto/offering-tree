class CreatePayRateBonuses < ActiveRecord::Migration[7.1]
  def change
    create_table :pay_rate_bonuses do |t|
      t.references :pay_rate, null: false, foreign_key: true
      t.float :rate_per_client, null: false
      t.integer :min_client_count
      t.integer :max_client_count

      t.timestamps
    end
  end
end