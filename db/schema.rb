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

ActiveRecord::Schema.define(version: 2022_03_01_174912) do

  create_table "halls", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "capacity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "total_seats"
    t.string "seats"
    t.boolean "verified", default: false
    t.integer "show_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["show_id"], name: "index_reservations_on_show_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "cancelled", default: false
    t.boolean "confirmed", default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "hall_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"hall\", \"start_time\"", name: "index_shows_on_hall_and_start_time", unique: true
    t.index ["hall_id"], name: "index_shows_on_hall_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
  end

  add_foreign_key "reservations", "shows"
  add_foreign_key "reservations", "users"
  add_foreign_key "shows", "halls"
end
