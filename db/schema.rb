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

ActiveRecord::Schema[8.0].define(version: 2025_07_19_205910) do
  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "org_name"
    t.string "short_name"
    t.string "logo"
    t.boolean "require_name"
    t.decimal "quoted_rate", precision: 8, scale: 2
    t.bigint "user_id"
    t.string "reverse_logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "invoices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.integer "invoice_number"
    t.decimal "total_amount", precision: 8, scale: 2
    t.decimal "tax_amount", precision: 8, scale: 2
    t.date "invoice_date"
    t.boolean "paid"
    t.string "pdf_address"
    t.text "button_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "note_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "note_categories_notes", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "note_category_id", null: false
    t.bigint "note_id", null: false
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "note"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_contents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "copy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminders", id: :integer, charset: "utf8mb3", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "completed"
    t.boolean "time_critical", default: false, null: false
    t.integer "task_id"
    t.date "reminder_date"
    t.date "due"
    t.integer "change_count"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["task_id"], name: "index_reminders_on_task_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "task_notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_notes_on_task_id"
  end

  create_table "tasks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "task_name"
    t.text "description"
    t.text "notes"
    t.string "status"
    t.date "due_date"
    t.date "date_completed"
    t.string "priority"
    t.integer "customer_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["customer_id"], name: "index_tasks_on_customer_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "work_periods", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "end_time", precision: nil
    t.datetime "start_time", precision: nil
    t.text "time_note"
    t.boolean "billable"
    t.integer "task_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["task_id"], name: "index_work_periods_on_task_id"
  end

  add_foreign_key "sessions", "users"
end
