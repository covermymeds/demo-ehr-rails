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

ActiveRecord::Schema.define(version: 20150402172928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cmm_callbacks", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pa_request_id"
  end

  add_index "cmm_callbacks", ["pa_request_id"], name: "index_cmm_callbacks_on_pa_request_id", using: :btree

  create_table "pa_requests", force: true do |t|
    t.integer  "prescription_id"
    t.boolean  "urgent"
    t.string   "form_id"
    t.string   "state"
    t.boolean  "sent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cmm_token"
    t.string   "cmm_link"
    t.string   "cmm_id"
    t.string   "cmm_workflow_status"
    t.text     "request_pages_actions"
    t.string   "cmm_outcome"
    t.integer  "prescriber_id"
  end

  add_index "pa_requests", ["prescription_id"], name: "index_pa_requests_on_prescription_id", using: :btree

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "date_of_birth"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "city"
    t.string   "zip"
    t.string   "phone_number"
    t.string   "gender"
    t.string   "email"
    t.string   "bin"
    t.string   "pcn"
    t.string   "group_id"
  end

  create_table "pharmacies", force: true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "fax"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip"
  end

  create_table "prescriptions", force: true do |t|
    t.string   "drug_number"
    t.integer  "quantity"
    t.string   "frequency"
    t.integer  "refills"
    t.boolean  "dispense_as_written"
    t.integer  "patient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "drug_name"
    t.string   "formulary_status"
    t.datetime "date_prescribed"
    t.boolean  "active"
    t.integer  "pharmacy_id"
  end

  add_index "prescriptions", ["patient_id"], name: "index_prescriptions_on_patient_id", using: :btree
  add_index "prescriptions", ["pharmacy_id"], name: "index_prescriptions_on_pharmacy_id", using: :btree

  create_table "roles", force: true do |t|
    t.string "description", null: false
  end

  create_table "standard_xmls", force: true do |t|
    t.string   "filename"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "npi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.integer  "role_id"
    t.string   "fax"
    t.boolean  "registered_with_cmm"
  end

  add_index "users", ["npi"], name: "index_users_on_npi", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end
