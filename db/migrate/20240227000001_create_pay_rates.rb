class CreatePayRates < ActiveRecord::Migration[7.1]
  def change
    create_table :pay_rates do |t|
      t.string :rate_name, null: false, limit: 50
      t.float :base_rate_per_client, null: false

      t.timestamps
    end

    add_index :pay_rates, :rate_name
  end
end