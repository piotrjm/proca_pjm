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

ActiveRecord::Schema.define(version: 20170721233828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessorizations", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_accessorizations_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_accessorizations_on_project_id"
    t.index ["role_id"], name: "index_accessorizations_on_role_id"
    t.index ["user_id", "project_id"], name: "index_accessorizations_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_accessorizations_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachmenable_type"
    t.bigint "attachmenable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachmenable_type", "attachmenable_id"], name: "index_attachments_on_attachmenable_type_and_attachmenable_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_customers_on_name"
  end

  create_table "point_files", force: :cascade do |t|
    t.bigint "project_id"
    t.date "load_date"
    t.string "load_file"
    t.integer "status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oi_2", limit: 16
    t.string "oi_3", limit: 255
    t.string "oi_4", limit: 100
    t.integer "oi_5"
    t.integer "oi_6"
    t.integer "oi_7"
    t.integer "oi_8"
    t.integer "oi_9"
    t.integer "oi_10"
    t.string "dp_2", limit: 250
    t.string "dp_3", limit: 13
    t.string "dp_4", limit: 10
    t.string "dp_5", limit: 100
    t.string "dp_6", limit: 250
    t.string "dp_7", limit: 50
    t.string "dp_8", limit: 6
    t.integer "ws_2"
    t.integer "ws_3"
    t.integer "ws_4"
    t.integer "ws_5"
    t.integer "ws_6"
    t.integer "ws_7"
    t.index ["load_date"], name: "index_point_files_on_load_date"
    t.index ["project_id"], name: "index_point_files_on_project_id"
    t.index ["status"], name: "index_point_files_on_status"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_project_statuses_on_name"
  end

  create_table "projects", force: :cascade do |t|
    t.string "number"
    t.date "registration"
    t.date "deadline"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_status_id", default: 1
    t.bigint "customer_id"
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["number"], name: "index_projects_on_number"
    t.index ["project_status_id"], name: "index_projects_on_project_status_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.boolean "special", default: false, null: false
    t.string "activities", default: [], array: true
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["special"], name: "index_roles_on_special"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.text "note", default: ""
    t.string "encrypted_password", default: "", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "ww_points", force: :cascade do |t|
    t.bigint "point_file_id"
    t.string "ww_2", limit: 10
    t.string "ww_3", limit: 100
    t.string "ww_4", limit: 100
    t.string "ww_5", limit: 100
    t.string "ww_6", limit: 100
    t.string "ww_7", limit: 7
    t.string "ww_8", limit: 100
    t.string "ww_9", limit: 7
    t.string "ww_10", limit: 250
    t.string "ww_11", limit: 5
    t.string "ww_12", limit: 50
    t.string "ww_13", limit: 6
    t.decimal "ww_14", precision: 7, scale: 4
    t.decimal "ww_15", precision: 7, scale: 4
    t.string "ww_16", limit: 100
    t.index ["point_file_id"], name: "index_ww_points_on_point_file_id"
    t.index ["ww_10"], name: "index_ww_points_on_ww_10"
    t.index ["ww_11"], name: "index_ww_points_on_ww_11"
    t.index ["ww_12"], name: "index_ww_points_on_ww_12"
    t.index ["ww_13"], name: "index_ww_points_on_ww_13"
    t.index ["ww_14"], name: "index_ww_points_on_ww_14"
    t.index ["ww_15"], name: "index_ww_points_on_ww_15"
    t.index ["ww_16"], name: "index_ww_points_on_ww_16"
    t.index ["ww_2"], name: "index_ww_points_on_ww_2"
    t.index ["ww_3"], name: "index_ww_points_on_ww_3"
    t.index ["ww_4"], name: "index_ww_points_on_ww_4"
    t.index ["ww_5"], name: "index_ww_points_on_ww_5"
    t.index ["ww_6"], name: "index_ww_points_on_ww_6"
    t.index ["ww_7"], name: "index_ww_points_on_ww_7"
    t.index ["ww_8"], name: "index_ww_points_on_ww_8"
    t.index ["ww_9"], name: "index_ww_points_on_ww_9"
  end

  create_table "zs_points", force: :cascade do |t|
    t.bigint "point_file_id"
    t.string "zs_2", limit: 10
    t.string "zs_3", limit: 100
    t.string "zs_4", limit: 100
    t.string "zs_5", limit: 100
    t.string "zs_6", limit: 100
    t.string "zs_7", limit: 7
    t.string "zs_8", limit: 100
    t.string "zs_9", limit: 7
    t.string "zs_10", limit: 250
    t.string "zs_11", limit: 5
    t.string "zs_12", limit: 50
    t.decimal "zs_13", precision: 7, scale: 4
    t.decimal "zs_14", precision: 7, scale: 4
    t.string "zs_15", limit: 100
    t.integer "zs_16"
    t.integer "zs_17"
    t.string "zs_18", limit: 100
    t.integer "zs_19"
    t.integer "zs_20"
    t.integer "zs_21"
    t.index ["point_file_id"], name: "index_zs_points_on_point_file_id"
    t.index ["zs_10"], name: "index_zs_points_on_zs_10"
    t.index ["zs_11"], name: "index_zs_points_on_zs_11"
    t.index ["zs_12"], name: "index_zs_points_on_zs_12"
    t.index ["zs_13"], name: "index_zs_points_on_zs_13"
    t.index ["zs_14"], name: "index_zs_points_on_zs_14"
    t.index ["zs_15"], name: "index_zs_points_on_zs_15"
    t.index ["zs_16"], name: "index_zs_points_on_zs_16"
    t.index ["zs_17"], name: "index_zs_points_on_zs_17"
    t.index ["zs_18"], name: "index_zs_points_on_zs_18"
    t.index ["zs_19"], name: "index_zs_points_on_zs_19"
    t.index ["zs_2"], name: "index_zs_points_on_zs_2"
    t.index ["zs_20"], name: "index_zs_points_on_zs_20"
    t.index ["zs_21"], name: "index_zs_points_on_zs_21"
    t.index ["zs_3"], name: "index_zs_points_on_zs_3"
    t.index ["zs_4"], name: "index_zs_points_on_zs_4"
    t.index ["zs_5"], name: "index_zs_points_on_zs_5"
    t.index ["zs_6"], name: "index_zs_points_on_zs_6"
    t.index ["zs_7"], name: "index_zs_points_on_zs_7"
    t.index ["zs_8"], name: "index_zs_points_on_zs_8"
    t.index ["zs_9"], name: "index_zs_points_on_zs_9"
  end

  add_foreign_key "point_files", "projects"
  add_foreign_key "projects", "customers"
  add_foreign_key "projects", "project_statuses"
  add_foreign_key "ww_points", "point_files"
  add_foreign_key "zs_points", "point_files"
end
