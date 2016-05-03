# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160503034850) do

  create_table "bookings", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "cleaner_id"
    t.date     "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "bookings", ["cleaner_id"], name: "index_bookings_on_cleaner_id"
  add_index "bookings", ["customer_id"], name: "index_bookings_on_customer_id"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cleaners", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "quality_score"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "working_cities", force: :cascade do |t|
    t.integer  "city_id"
    t.integer  "cleaner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "working_cities", ["city_id"], name: "index_working_cities_on_city_id"
  add_index "working_cities", ["cleaner_id"], name: "index_working_cities_on_cleaner_id"

end
