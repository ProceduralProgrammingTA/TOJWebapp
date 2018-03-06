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

ActiveRecord::Schema.define(version: 20170627075953) do

  create_table "admins", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["name"], name: "index_admins_on_name", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "reports", force: :cascade do |t|
    t.string   "task_title"
    t.string   "file_name"
    t.string   "student_comment"
    t.string   "ta_comment"
    t.integer  "student_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "students", ["name"], name: "index_students_on_name", unique: true
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true

  create_table "submissions", force: :cascade do |t|
    t.string   "message"
    t.boolean  "is_accepted"
    t.integer  "student_id"
    t.integer  "task_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "ta_check",     default: 0
    t.string   "ta_comment"
    t.string   "status"
    t.boolean  "is_completed", default: false
    t.string   "code"
  end

  add_index "submissions", ["created_at"], name: "index_submissions_on_created_at"
  add_index "submissions", ["student_id"], name: "index_submissions_on_student_id"
  add_index "submissions", ["task_id"], name: "index_submissions_on_task_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deadline"
    t.boolean  "is_public",    default: false
    t.datetime "last_rejudge"
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "file_name"
    t.string   "content"
    t.string   "memo"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
