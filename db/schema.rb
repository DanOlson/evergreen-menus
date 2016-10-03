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

ActiveRecord::Schema.define(version: 20161003023052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",                       null: false
    t.boolean  "active",     default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "api_keys", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.string   "access_token", limit: 255, null: false
    t.datetime "expires_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  end

  create_table "beer_establishments", force: :cascade do |t|
    t.integer "beer_id"
    t.integer "establishment_id"
    t.index ["beer_id", "establishment_id"], name: "index_beer_establishments_on_beer_id_and_establishment_id", using: :btree
  end

  create_table "beers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_beers_on_name", using: :btree
  end

  create_table "establishment_suggestions", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "beer_list_url", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "establishments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",               precision: 9, scale: 6
    t.decimal  "longitude",              precision: 9, scale: 6
    t.string   "url",        limit: 255
    t.boolean  "active",                                         default: true
  end

  create_table "list_updates", force: :cascade do |t|
    t.integer  "establishment_id"
    t.string   "status",           limit: 50,  null: false
    t.string   "notes",            limit: 255
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrapers", force: :cascade do |t|
    t.integer  "establishment_id"
    t.string   "scraper_class_name", limit: 255
    t.time     "scheduled_run_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_ran_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "username",               limit: 255,              null: false
    t.string   "email",                  limit: 255,              null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
