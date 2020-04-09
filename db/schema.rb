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

ActiveRecord::Schema.define(version: 2020_04_09_193056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.integer "member_quantity"
    t.bigint "genre_id", null: false
    t.string "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_artists_on_deleted_at"
    t.index ["genre_id"], name: "index_artists_on_genre_id"
    t.index ["name"], name: "index_artists_on_name", unique: true
  end

  create_table "artists_events", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "event_id", null: false
    t.index ["artist_id"], name: "index_artists_events_on_artist_id"
    t.index ["event_id"], name: "index_artists_events_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "kind"
    t.date "occurred_on"
    t.string "location"
    t.date "line_up_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone"
    t.index ["kind"], name: "index_events_on_kind"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_genres_on_deleted_at"
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.string "time_zone"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "artists", "genres"
  add_foreign_key "artists_events", "artists"
  add_foreign_key "artists_events", "events"
  add_foreign_key "events", "users"
end
