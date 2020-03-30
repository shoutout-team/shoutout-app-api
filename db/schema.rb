# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_30_160538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "app_clients", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.string "api_key", null: false
    t.string "host"
    t.integer "user_id"
    t.boolean "approved", default: false, null: false
    t.boolean "active", default: false, null: false
    t.jsonb "properties", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_app_clients_on_active"
    t.index ["api_key"], name: "index_app_clients_on_api_key", unique: true
    t.index ["approved"], name: "index_app_clients_on_approved"
    t.index ["properties"], name: "index_app_clients_on_properties", using: :gin
    t.index ["user_id"], name: "index_app_clients_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "title", null: false
    t.integer "category", null: false
    t.string "slug", null: false
    t.string "postcode", null: false
    t.string "city", null: false
    t.string "street", null: false
    t.string "street_number", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.jsonb "properties", default: {}, null: false
    t.boolean "active", default: true, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "gid", null: false
    t.boolean "approved", default: false, null: false
    t.index ["active"], name: "index_companies_on_active"
    t.index ["approved"], name: "index_companies_on_approved"
    t.index ["category"], name: "index_companies_on_category"
    t.index ["gid"], name: "index_companies_on_gid", unique: true
    t.index ["latitude"], name: "index_companies_on_latitude"
    t.index ["longitude"], name: "index_companies_on_longitude"
    t.index ["name"], name: "index_companies_on_name"
    t.index ["properties"], name: "index_companies_on_properties", using: :gin
    t.index ["slug"], name: "index_companies_on_slug"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "postcode", null: false
    t.string "federate_state", null: false
    t.integer "osm_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["federate_state"], name: "index_locations_on_federate_state"
    t.index ["name"], name: "index_locations_on_name"
    t.index ["osm_id"], name: "index_locations_on_osm_id"
    t.index ["postcode"], name: "index_locations_on_postcode"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "entity", null: false
    t.string "kind", null: false
    t.string "key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "filename"
    t.index ["key"], name: "index_uploads_on_key"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.integer "role", default: 0, null: false
    t.jsonb "properties", default: {}, null: false
    t.jsonb "preferences", default: {}, null: false
    t.boolean "approved", default: false, null: false
    t.string "encrypted_password", null: false
    t.datetime "remember_created_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "gid", null: false
    t.string "developer_key"
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["developer_key"], name: "index_users_on_developer_key"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gid"], name: "index_users_on_gid", unique: true
    t.index ["preferences"], name: "index_users_on_preferences", using: :gin
    t.index ["properties"], name: "index_users_on_properties", using: :gin
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
