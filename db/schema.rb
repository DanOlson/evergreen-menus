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

ActiveRecord::Schema.define(version: 20140505010827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: true do |t|
    t.integer  "user_id",      null: false
    t.string   "access_token", null: false
    t.datetime "expires_at",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree

  create_table "beer_establishments", force: true do |t|
    t.integer "beer_id"
    t.integer "establishment_id"
  end

  add_index "beer_establishments", ["beer_id", "establishment_id"], name: "index_beer_establishments_on_beer_id_and_establishment_id", using: :btree

  create_table "beers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beers", ["name"], name: "index_beers_on_name", using: :btree

  create_table "establishment_suggestions", force: true do |t|
    t.string   "name",          null: false
    t.string   "beer_list_url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "establishments", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",   precision: 9, scale: 6
    t.decimal  "longitude",  precision: 9, scale: 6
    t.string   "url"
    t.boolean  "active",                             default: true
  end

  create_table "list_updates", force: true do |t|
    t.integer  "establishment_id"
    t.string   "status",           limit: 50, null: false
    t.string   "notes"
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrapers", force: true do |t|
    t.integer  "establishment_id"
    t.string   "scraper_class_name"
    t.time     "scheduled_run_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_ran_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
