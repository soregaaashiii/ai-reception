# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_21_010000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "assignee_id"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.datetime "ends_at", null: false
    t.bigint "inquiry_id"
    t.bigint "location_id"
    t.bigint "organization_id", null: false
    t.datetime "starts_at", null: false
    t.string "status", default: "confirmed", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_appointments_on_assignee_id"
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["inquiry_id"], name: "index_appointments_on_inquiry_id"
    t.index ["location_id"], name: "index_appointments_on_location_id"
    t.index ["organization_id"], name: "index_appointments_on_organization_id"
  end

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["organization_id", "phone"], name: "index_customers_on_organization_id_and_phone"
    t.index ["organization_id"], name: "index_customers_on_organization_id"
  end

  create_table "improvement_candidates", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.text "draft_answer", null: false
    t.decimal "growth_rate", default: "0.0", null: false
    t.integer "inquiry_count", default: 0, null: false
    t.bigint "organization_id", null: false
    t.text "representative_question", null: false
    t.string "sales_impact", default: "medium", null: false
    t.jsonb "similar_questions", default: [], null: false
    t.bigint "source_message_id"
    t.string "status", default: "pending", null: false
    t.integer "unanswered_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_improvement_candidates_on_organization_id"
    t.index ["source_message_id"], name: "index_improvement_candidates_on_source_message_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.boolean "ai_completed", default: false, null: false
    t.bigint "assignee_id"
    t.string "category", null: false
    t.string "channel", null: false
    t.string "conversion_stage"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.text "customer_request"
    t.string "lead_level", default: "medium", null: false
    t.bigint "location_id"
    t.text "next_action"
    t.bigint "organization_id", null: false
    t.boolean "outside_business_hours", default: false, null: false
    t.datetime "received_at", null: false
    t.integer "recording_duration_seconds"
    t.string "recording_name"
    t.integer "revenue_yen", default: 0, null: false
    t.string "status", default: "new", null: false
    t.text "summary", null: false
    t.text "transcript"
    t.text "unanswered_portion"
    t.datetime "updated_at", null: false
    t.string "urgency", default: "normal", null: false
    t.index ["assignee_id"], name: "index_inquiries_on_assignee_id"
    t.index ["customer_id"], name: "index_inquiries_on_customer_id"
    t.index ["location_id"], name: "index_inquiries_on_location_id"
    t.index ["organization_id", "received_at"], name: "index_inquiries_on_organization_id_and_received_at"
    t.index ["organization_id", "status"], name: "index_inquiries_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_inquiries_on_organization_id"
  end

  create_table "inquiry_knowledge_uses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "inquiry_id", null: false
    t.bigint "knowledge_item_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inquiry_id", "knowledge_item_id"], name: "idx_on_inquiry_id_knowledge_item_id_a19da0e2d9", unique: true
    t.index ["inquiry_id"], name: "index_inquiry_knowledge_uses_on_inquiry_id"
    t.index ["knowledge_item_id"], name: "index_inquiry_knowledge_uses_on_knowledge_item_id"
    t.index ["organization_id"], name: "index_inquiry_knowledge_uses_on_organization_id"
  end

  create_table "knowledge_histories", force: :cascade do |t|
    t.string "action", null: false
    t.string "actor_name", null: false
    t.datetime "created_at", null: false
    t.bigint "knowledge_item_id"
    t.bigint "organization_id", null: false
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["knowledge_item_id"], name: "index_knowledge_histories_on_knowledge_item_id"
    t.index ["organization_id"], name: "index_knowledge_histories_on_organization_id"
  end

  create_table "knowledge_items", force: :cascade do |t|
    t.text "answer", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.bigint "organization_id", null: false
    t.text "question", null: false
    t.integer "resolution_count", default: 0, null: false
    t.text "source", null: false
    t.string "status", default: "published", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "usage_count", default: 0, null: false
    t.index ["organization_id"], name: "index_knowledge_items_on_organization_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "phone"
    t.boolean "primary", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "name"], name: "index_locations_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "inquiry_id", null: false
    t.bigint "organization_id", null: false
    t.string "speaker", null: false
    t.datetime "spoken_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inquiry_id"], name: "index_messages_on_inquiry_id"
    t.index ["organization_id"], name: "index_messages_on_organization_id"
  end

  create_table "notification_deliveries", force: :cascade do |t|
    t.string "channel", null: false
    t.datetime "created_at", null: false
    t.datetime "delivered_at"
    t.string "destination", null: false
    t.text "error_message"
    t.bigint "inquiry_id", null: false
    t.bigint "organization_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["inquiry_id"], name: "index_notification_deliveries_on_inquiry_id"
    t.index ["organization_id"], name: "index_notification_deliveries_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.jsonb "business_days", default: ["月", "火", "水", "木", "金"], null: false
    t.string "business_hours", default: "9:00〜18:00", null: false
    t.datetime "created_at", null: false
    t.text "holidays"
    t.string "industry"
    t.text "initial_faq"
    t.text "initial_materials"
    t.string "name", null: false
    t.string "notification_email"
    t.boolean "reception_enabled", default: false, null: false
    t.string "service_name", default: "AI受付", null: false
    t.datetime "setup_completed_at"
    t.integer "setup_step", default: 1, null: false
    t.string "slack_destination"
    t.string "status", default: "trial", null: false
    t.string "time_zone", default: "Asia/Tokyo", null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "last_signed_in_at"
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index ["organization_id", "role"], name: "index_users_on_organization_id_and_role"
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "appointments", "customers"
  add_foreign_key "appointments", "inquiries"
  add_foreign_key "appointments", "locations"
  add_foreign_key "appointments", "organizations"
  add_foreign_key "appointments", "users", column: "assignee_id"
  add_foreign_key "customers", "organizations"
  add_foreign_key "improvement_candidates", "messages", column: "source_message_id"
  add_foreign_key "improvement_candidates", "organizations"
  add_foreign_key "inquiries", "customers"
  add_foreign_key "inquiries", "locations"
  add_foreign_key "inquiries", "organizations"
  add_foreign_key "inquiries", "users", column: "assignee_id"
  add_foreign_key "inquiry_knowledge_uses", "inquiries"
  add_foreign_key "inquiry_knowledge_uses", "knowledge_items"
  add_foreign_key "inquiry_knowledge_uses", "organizations"
  add_foreign_key "knowledge_histories", "knowledge_items"
  add_foreign_key "knowledge_histories", "organizations"
  add_foreign_key "knowledge_items", "organizations"
  add_foreign_key "locations", "organizations"
  add_foreign_key "messages", "inquiries"
  add_foreign_key "messages", "organizations"
  add_foreign_key "notification_deliveries", "inquiries"
  add_foreign_key "notification_deliveries", "organizations"
  add_foreign_key "users", "organizations"
end
