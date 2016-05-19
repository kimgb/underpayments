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

ActiveRecord::Schema.define(version: 20160506044902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "addresses", force: :cascade do |t|
    t.string   "street_address"
    t.string   "town"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "claim_companies", force: :cascade do |t|
    t.integer  "claim_id"
    t.integer  "company_id"
    t.boolean  "is_active"
    t.boolean  "is_employer"
    t.boolean  "is_workplace"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "claim_companies", ["claim_id"], name: "index_claim_companies_on_claim_id", using: :btree
  add_index "claim_companies", ["company_id"], name: "index_claim_companies_on_company_id", using: :btree

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
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "submitted_for_review"
    t.datetime "submitted_on"
    t.boolean  "payslips_received",                             default: false
    t.boolean  "pieceworker",                                   default: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "abn"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "contact"
  end

  create_table "company_addresses", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "address_id"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "company_addresses", ["address_id"], name: "index_company_addresses_on_address_id", using: :btree
  add_index "company_addresses", ["company_id"], name: "index_company_addresses_on_company_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "evidence"
    t.boolean  "wage_evidence"
    t.boolean  "time_evidence"
    t.date     "coverage_start_date"
    t.date     "coverage_end_date"
    t.integer  "claim_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.decimal  "hours"
    t.decimal  "wages"
    t.text     "statement"
  end

  add_index "documents", ["claim_id"], name: "index_documents_on_claim_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.hstore   "skin"
    t.integer  "supergroup_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree
  add_index "groups", ["supergroup_id"], name: "index_groups_on_supergroup_id", using: :btree

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
    t.integer  "address_id"
  end

  add_index "profiles", ["address_id"], name: "index_profiles_on_address_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "supergroups", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text   "description"
    t.string "www"
  end

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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.integer  "group_id"
  end

  add_index "users", ["claim_id"], name: "index_users_on_claim_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "claim_companies", "claims"
  add_foreign_key "claim_companies", "companies"
  add_foreign_key "company_addresses", "addresses"
  add_foreign_key "company_addresses", "companies"
  add_foreign_key "documents", "claims"
  add_foreign_key "groups", "supergroups"
  add_foreign_key "profiles", "addresses"
  add_foreign_key "profiles", "users"
  add_foreign_key "users", "claims"
  add_foreign_key "users", "groups"
end
