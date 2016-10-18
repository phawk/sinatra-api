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

ActiveRecord::Schema.define(version: 20140516135440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "citext"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token",                 null: false
    t.integer  "client_application_id", null: false
    t.integer  "user_id",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["client_application_id"], name: "index_access_tokens_on_client_application_id", using: :btree
    t.index ["token"], name: "index_access_tokens_on_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_access_tokens_on_user_id", using: :btree
  end

  create_table "client_applications", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "client_id",                     null: false
    t.string   "client_secret",                 null: false
    t.boolean  "in_house_app",  default: false, null: false
    t.integer  "user_id",                       null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["client_id"], name: "index_client_applications_on_client_id", using: :btree
    t.index ["user_id"], name: "index_client_applications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
