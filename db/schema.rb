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

ActiveRecord::Schema[7.0].define(version: 2024_08_08_105625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.string "temporary_address"
    t.string "permanent_address"
    t.index ["company_id"], name: "index_addresses_on_company_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "user_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "joining_date"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_admins_on_company_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_announcements_on_company_id"
  end

  create_table "apply_leaves", force: :cascade do |t|
    t.string "allowed_leave_type"
    t.integer "allowed_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.float "allowed_hours"
    t.integer "paid_type", default: 0
    t.index ["company_id"], name: "index_apply_leaves_on_company_id"
  end

  create_table "assigned_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "evaluation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_assigned_users_on_company_id"
    t.index ["evaluation_id"], name: "index_assigned_users_on_evaluation_id"
    t.index ["user_id"], name: "index_assigned_users_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visibility", default: true
    t.bigint "company_id"
    t.string "attachment_type"
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable"
    t.index ["company_id"], name: "index_attachments_on_company_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "verify_mode"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_machine_code"
    t.index ["company_id"], name: "index_attendances_on_company_id"
    t.index ["user_machine_code"], name: "index_attendances_on_user_machine_code"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "auth_token"
    t.datetime "last_sync_at"
  end

  create_table "company_assets", force: :cascade do |t|
    t.string "model"
    t.string "company_assets_type"
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "added_by"
    t.bigint "company_id"
    t.string "unique_identifier"
    t.datetime "deleted_at"
    t.date "purchase_date"
    t.integer "status", default: 0
    t.decimal "price"
    t.index ["company_id"], name: "index_company_assets_on_company_id"
    t.index ["deleted_at"], name: "index_company_assets_on_deleted_at"
    t.index ["user_id"], name: "index_company_assets_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "employee_groups", force: :cascade do |t|
    t.bigint "code"
    t.string "name"
    t.text "description"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "employee"
    t.index ["company_id"], name: "index_employee_groups_on_company_id"
  end

  create_table "evaluation_feed_backs", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "feedback"
    t.bigint "evaluation_option_id"
    t.bigint "assigned_user_id", null: false
    t.bigint "company_id"
    t.index ["assigned_user_id"], name: "index_evaluation_feed_backs_on_assigned_user_id"
    t.index ["company_id"], name: "index_evaluation_feed_backs_on_company_id"
    t.index ["question_id"], name: "index_evaluation_feed_backs_on_question_id"
  end

  create_table "evaluation_options", force: :cascade do |t|
    t.string "option"
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_evaluation_options_on_company_id"
    t.index ["question_id"], name: "index_evaluation_options_on_question_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "status"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_evaluations_on_company_id"
  end

  create_table "help_documents", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_help_documents_on_company_id"
  end

  create_table "histories", force: :cascade do |t|
    t.bigint "company_asset_id", null: false
    t.bigint "user_id", null: false
    t.date "given_date"
    t.date "return_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.string "assigned_by"
    t.index ["company_asset_id"], name: "index_histories_on_company_asset_id"
    t.index ["company_id"], name: "index_histories_on_company_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "leaves", force: :cascade do |t|
    t.datetime "date_from"
    t.datetime "date_to"
    t.integer "status", default: 0
    t.float "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.float "request_leaves", default: 0.0
    t.bigint "apply_leave_id"
    t.bigint "company_id"
    t.integer "short_type"
    t.datetime "deleted_at"
    t.time "from_time"
    t.time "to_time"
    t.index ["apply_leave_id"], name: "index_leaves_on_apply_leave_id"
    t.index ["company_id"], name: "index_leaves_on_company_id"
    t.index ["deleted_at"], name: "index_leaves_on_deleted_at"
    t.index ["user_id"], name: "index_leaves_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "work_location"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.text "address"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_locations_on_company_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notable_type"
    t.integer "notable_id"
    t.integer "user_id"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_notes_on_company_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_notifications_on_company_id"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payment_method"
    t.string "bank_name"
    t.string "branch_name"
    t.string "branch_code"
    t.string "account_number"
    t.string "bank_code"
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_payments_on_company_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.string "controller"
    t.string "controller_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "evaluation_id"
    t.integer "question_type"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_questions_on_company_id"
    t.index ["evaluation_id"], name: "index_questions_on_evaluation_id"
  end

  create_table "requests", force: :cascade do |t|
    t.json "details"
    t.string "request_type"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_requests_on_company_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
  end

  create_table "roles_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_roles_permissions_on_permission_id"
    t.index ["role_id"], name: "index_roles_permissions_on_role_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.string "name"
    t.integer "working_hours"
    t.time "start_time"
    t.time "end_time"
    t.text "working_days"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_shifts_on_company_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "subject"
    t.string "email"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_supports_on_company_id"
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "time_policies", force: :cascade do |t|
    t.json "missing_attendance"
    t.json "late_arrival"
    t.json "early_out"
    t.json "hours_per_day"
    t.json "missing_swipe"
    t.json "overtime_policy"
    t.bigint "employee_group_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_time_policies_on_company_id"
    t.index ["employee_group_id"], name: "index_time_policies_on_employee_group_id"
  end

  create_table "time_sheets", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "date"
    t.datetime "time"
    t.integer "status", default: 0
    t.bigint "company_id"
    t.index ["company_id"], name: "index_time_sheets_on_company_id"
  end

  create_table "upcoming_holidays", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_upcoming_holidays_on_company_id"
  end

  create_table "user_designations", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_designations_on_company_id"
  end

  create_table "user_projects", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_user_projects_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0
    t.string "first_name"
    t.string "last_name"
    t.bigint "address_id"
    t.string "phone_number"
    t.boolean "can_contact", default: false
    t.date "joining_date"
    t.integer "employment_type"
    t.integer "report_to_id"
    t.integer "status", default: 0
    t.bigint "company_id"
    t.integer "allow_leave_approval", default: 0
    t.datetime "deleted_at"
    t.bigint "role_id"
    t.string "father_name"
    t.string "mother_name"
    t.integer "blood_group"
    t.integer "qualification"
    t.integer "martial_status"
    t.date "date_of_birth"
    t.integer "religion"
    t.string "cnic_number"
    t.string "passport_number"
    t.string "home_phone_no"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone_no"
    t.date "probation_end_date"
    t.date "hire_date"
    t.integer "gender"
    t.string "eobi_number"
    t.string "ntn_number"
    t.integer "salary_type"
    t.string "base_salary"
    t.date "starting_date"
    t.bigint "department_id"
    t.bigint "location_id"
    t.bigint "shift_id"
    t.bigint "user_designation_id"
    t.string "machine_code"
    t.bigint "employee_group_id"
    t.integer "missing_attendance_deduction", default: 0
    t.integer "early_out_deduction", default: 0
    t.integer "late_arrival_deduction", default: 0
    t.integer "missing_swipe_deduction", default: 0
    t.integer "hours_deduction", default: 0
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_group_id"], name: "index_users_on_employee_group_id"
    t.index ["location_id"], name: "index_users_on_location_id"
    t.index ["machine_code"], name: "index_users_on_machine_code"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["shift_id"], name: "index_users_on_shift_id"
    t.index ["user_designation_id"], name: "index_users_on_user_designation_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "companies"
  add_foreign_key "addresses", "users"
  add_foreign_key "admins", "companies"
  add_foreign_key "announcements", "companies"
  add_foreign_key "apply_leaves", "companies"
  add_foreign_key "assigned_users", "companies"
  add_foreign_key "assigned_users", "evaluations"
  add_foreign_key "assigned_users", "users"
  add_foreign_key "attachments", "companies"
  add_foreign_key "attendances", "companies"
  add_foreign_key "company_assets", "companies"
  add_foreign_key "company_assets", "users"
  add_foreign_key "departments", "companies"
  add_foreign_key "employee_groups", "companies"
  add_foreign_key "evaluation_feed_backs", "assigned_users"
  add_foreign_key "evaluation_feed_backs", "companies"
  add_foreign_key "evaluation_feed_backs", "questions"
  add_foreign_key "evaluation_options", "companies"
  add_foreign_key "evaluation_options", "questions"
  add_foreign_key "evaluations", "companies"
  add_foreign_key "help_documents", "companies"
  add_foreign_key "histories", "companies"
  add_foreign_key "histories", "company_assets"
  add_foreign_key "histories", "users"
  add_foreign_key "leaves", "apply_leaves"
  add_foreign_key "leaves", "companies"
  add_foreign_key "leaves", "users"
  add_foreign_key "locations", "companies"
  add_foreign_key "notes", "companies"
  add_foreign_key "notifications", "companies"
  add_foreign_key "payments", "companies"
  add_foreign_key "payments", "users"
  add_foreign_key "projects", "companies"
  add_foreign_key "questions", "companies"
  add_foreign_key "questions", "evaluations"
  add_foreign_key "requests", "companies"
  add_foreign_key "requests", "users"
  add_foreign_key "roles", "companies"
  add_foreign_key "roles_permissions", "permissions"
  add_foreign_key "roles_permissions", "roles"
  add_foreign_key "shifts", "companies"
  add_foreign_key "supports", "companies"
  add_foreign_key "supports", "users"
  add_foreign_key "time_policies", "companies"
  add_foreign_key "time_sheets", "companies"
  add_foreign_key "upcoming_holidays", "companies"
  add_foreign_key "user_designations", "companies"
  add_foreign_key "user_projects", "companies"
  add_foreign_key "users", "addresses"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "employee_groups"
  add_foreign_key "users", "locations"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "shifts"
  add_foreign_key "users", "user_designations"
end
