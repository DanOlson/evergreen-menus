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

ActiveRecord::Schema.define(version: 20131208013216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "name",          null: false
    t.string "beer_list_url", null: false
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

end
