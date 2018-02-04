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

ActiveRecord::Schema.define(version: 20180204041241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",                       null: false
    t.boolean  "active",     default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "api_keys", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.string   "access_token", null: false
    t.datetime "expires_at",   null: false
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
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "establishment_id"
    t.integer  "price_in_cents"
    t.text     "description"
    t.integer  "list_id"
    t.string   "labels"
    t.index ["name"], name: "index_beers_on_name", using: :btree
  end

  create_table "digital_display_menu_lists", force: :cascade do |t|
    t.integer  "digital_display_menu_id",                null: false
    t.integer  "list_id",                                null: false
    t.integer  "position",                               null: false
    t.boolean  "show_price_on_menu",      default: true, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "digital_display_menus", force: :cascade do |t|
    t.string   "name",                                                    null: false
    t.integer  "establishment_id",                                        null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.boolean  "horizontal_orientation",                   default: true, null: false
    t.integer  "rotate_interval_milliseconds"
    t.string   "font",                         limit: 100
    t.string   "background_hex_color",         limit: 10
    t.string   "text_hex_color",               limit: 10
    t.string   "list_title_hex_color",         limit: 10
    t.string   "theme",                        limit: 40
  end

  create_table "establishment_staff_assignments", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "establishment_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "establishment_suggestions", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "beer_list_url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "establishments", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",       precision: 9, scale: 6
    t.decimal  "longitude",      precision: 9, scale: 6
    t.string   "url"
    t.boolean  "active",                                 default: true
    t.integer  "account_id"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
  end

  create_table "invitation_establishment_assignments", force: :cascade do |t|
    t.integer  "user_invitation_id", null: false
    t.integer  "establishment_id",   null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "list_updates", force: :cascade do |t|
    t.integer  "establishment_id"
    t.string   "status",           limit: 50, null: false
    t.string   "notes"
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "establishment_id",                           null: false
    t.boolean  "show_price",                  default: true, null: false
    t.boolean  "show_description",            default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "type",             limit: 40
    t.index ["type"], name: "index_lists_on_type", using: :btree
  end

  create_table "menu_lists", force: :cascade do |t|
    t.integer  "menu_id",                           null: false
    t.integer  "list_id",                           null: false
    t.integer  "position",                          null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "show_price_on_menu", default: true, null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string   "name",                                           null: false
    t.integer  "establishment_id",                               null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "font"
    t.integer  "font_size"
    t.integer  "number_of_columns",                  default: 1
    t.string   "template",                limit: 60
    t.time     "availability_start_time"
    t.time     "availability_end_time"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scrapers", force: :cascade do |t|
    t.integer  "establishment_id"
    t.string   "scraper_class_name"
    t.time     "scheduled_run_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_ran_at"
  end

  create_table "user_invitations", force: :cascade do |t|
    t.string   "first_name",                        null: false
    t.string   "last_name"
    t.string   "email",                             null: false
    t.integer  "inviting_user_id",                  null: false
    t.integer  "account_id",                        null: false
    t.boolean  "accepted",          default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "accepting_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username",                            null: false
    t.string   "email",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "account_id"
    t.integer  "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "web_menu_lists", force: :cascade do |t|
    t.integer  "web_menu_id",                             null: false
    t.integer  "list_id",                                 null: false
    t.integer  "position",                                null: false
    t.boolean  "show_price_on_menu",       default: true, null: false
    t.boolean  "show_description_on_menu", default: true, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "web_menus", force: :cascade do |t|
    t.string   "name",                    null: false
    t.integer  "establishment_id",        null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.time     "availability_start_time"
    t.time     "availability_end_time"
  end

  add_foreign_key "beers", "lists"
  add_foreign_key "digital_display_menu_lists", "digital_display_menus"
  add_foreign_key "digital_display_menu_lists", "lists"
  add_foreign_key "digital_display_menus", "establishments"
  add_foreign_key "establishment_staff_assignments", "establishments"
  add_foreign_key "establishment_staff_assignments", "users"
  add_foreign_key "establishments", "accounts"
  add_foreign_key "invitation_establishment_assignments", "establishments"
  add_foreign_key "invitation_establishment_assignments", "user_invitations"
  add_foreign_key "lists", "establishments"
  add_foreign_key "menu_lists", "lists"
  add_foreign_key "menu_lists", "menus"
  add_foreign_key "menus", "establishments"
  add_foreign_key "user_invitations", "accounts"
  add_foreign_key "user_invitations", "users", column: "accepting_user_id"
  add_foreign_key "user_invitations", "users", column: "inviting_user_id"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "roles"
  add_foreign_key "web_menu_lists", "lists"
  add_foreign_key "web_menu_lists", "web_menus"
  add_foreign_key "web_menus", "establishments"
end
