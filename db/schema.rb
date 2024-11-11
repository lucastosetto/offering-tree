# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_27_000002) do
  create_table "pay_rate_bonuses", force: :cascade do |t|
    t.integer "pay_rate_id", null: false
    t.decimal "rate_per_client", precision: 10, scale: 2, null: false
    t.integer "min_client_count"
    t.integer "max_client_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pay_rate_id"], name: "index_pay_rate_bonuses_on_pay_rate_id"
  end

  create_table "pay_rates", force: :cascade do |t|
    t.string "rate_name", limit: 50, null: false
    t.decimal "base_rate_per_client", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rate_name"], name: "index_pay_rates_on_rate_name"
  end

  add_foreign_key "pay_rate_bonuses", "pay_rates"
end
