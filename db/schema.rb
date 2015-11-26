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

ActiveRecord::Schema.define(version: 20151113061316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "addresses", force: :cascade do |t|
    t.string   "street_address"
    t.string   "secondary_street_address"
    t.string   "town"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree

  create_table "claims", force: :cascade do |t|
    t.string   "status"
    t.string   "comment"
    t.string   "award"
    t.string   "lost_wages"
    t.integer  "total_hours"
    t.decimal  "hourly_pay",          precision: 10, scale: 2
    t.date     "employment_began_on"
    t.date     "employment_ended_on"
    t.string   "employment_type"
    t.boolean  "regular_hours"
    t.hstore   "exemplary_week"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "file"
    t.integer  "claim_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "documents", ["claim_id"], name: "index_documents_on_claim_id", using: :btree

  create_table "employers", force: :cascade do |t|
    t.string   "name"
    t.string   "abn"
    t.string   "phone"
    t.string   "email"
    t.integer  "claim_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "employers", ["claim_id"], name: "index_employers_on_claim_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "family_name"
    t.string   "given_name"
    t.date     "date_of_birth"
    t.string   "phone"
    t.string   "preferred_language"
    t.string   "follow_up_detail"
    t.boolean  "admin",                  default: false
    t.integer  "claim_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["claim_id"], name: "index_users_on_claim_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "documents", "claims"
  add_foreign_key "employers", "claims"
  add_foreign_key "users", "claims"
end
