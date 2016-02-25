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

ActiveRecord::Schema.define(version: 20160224235909) do

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
    t.decimal  "weekly_hours",         precision: 10, scale: 2
    t.decimal  "hourly_pay",           precision: 10, scale: 2
    t.date     "employment_began_on"
    t.date     "employment_ended_on"
    t.string   "employment_type"
    t.boolean  "regular_hours"
    t.hstore   "exemplary_week"
    t.integer  "employer_id"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "workplace_id"
    t.boolean  "submitted_for_review"
    t.datetime "submitted_on"
    t.boolean  "payslips_received",                             default: false
  end

  add_index "claims", ["employer_id"], name: "index_claims_on_employer_id", using: :btree
  add_index "claims", ["workplace_id"], name: "index_claims_on_workplace_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "file"
    t.boolean  "wage_evidence"
    t.boolean  "time_evidence"
    t.date     "coverage_start_date"
    t.date     "coverage_end_date"
    t.integer  "claim_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.decimal  "hours"
    t.decimal  "wages"
  end

  add_index "documents", ["claim_id"], name: "index_documents_on_claim_id", using: :btree

  create_table "employers", force: :cascade do |t|
    t.string   "name"
    t.string   "abn"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "contact"
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "family_name"
    t.string   "given_name"
    t.date     "date_of_birth"
    t.string   "phone"
    t.string   "preferred_language"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "preferred_name"
    t.string   "gender"
    t.string   "visa"
    t.string   "nationality"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

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
    t.boolean  "admin",                  default: false
    t.integer  "claim_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["claim_id"], name: "index_users_on_claim_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workplaces", force: :cascade do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "abn"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "claims", "employers"
  add_foreign_key "claims", "workplaces"
  add_foreign_key "documents", "claims"
  add_foreign_key "profiles", "users"
  add_foreign_key "users", "claims"
end
