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

ActiveRecord::Schema.define(version: 2025_11_08_183459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allowed_emails", force: :cascade do |t|
    t.string "email"
    t.string "role"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_allowed_emails_on_company_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "bill_type", null: false
    t.string "status", default: "pending", null: false
    t.datetime "submitted_at", null: false
    t.datetime "reviewed_at"
    t.bigint "company_id", null: false
    t.bigint "employee_id", null: false
    t.integer "reviewed_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_bills_on_company_id"
    t.index ["employee_id", "status"], name: "index_bills_on_employee_id_and_status"
    t.index ["employee_id"], name: "index_bills_on_employee_id"
    t.index ["reviewed_by_user_id"], name: "index_bills_on_reviewed_by_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "company_id"
    t.bigint "user_id"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "designation"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  add_foreign_key "allowed_emails", "companies"
  add_foreign_key "bills", "companies"
  add_foreign_key "bills", "employees"
  add_foreign_key "departments", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "users"
  add_foreign_key "users", "companies"
end
