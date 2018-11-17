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

ActiveRecord::Schema.define(version: 20181116043056) do

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "player_id"
    t.integer "micropost_id"
    t.integer "parent_id"
    t.integer "replies_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["micropost_id"], name: "index_comments_on_micropost_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["player_id"], name: "index_comments_on_player_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "team_id"
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.integer "from_id"
    t.integer "to_id"
    t.string "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id", "created_at"], name: "index_messages_on_room_id_and_created_at"
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.integer "team_id"
    t.integer "comments_count", default: 0, null: false
    t.string "in_reply_to"
    t.string "team_name"
    t.index ["player_id", "created_at"], name: "index_microposts_on_player_id_and_created_at"
    t.index ["player_id"], name: "index_microposts_on_player_id"
    t.index ["team_id"], name: "index_microposts_on_team_id"
  end

  create_table "parents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "team_manager", default: false
    t.integer "number"
    t.string "position"
    t.float "height"
    t.float "weight"
    t.integer "grade"
    t.string "old_school"
    t.boolean "follow_notification", default: false
    t.integer "game_count", default: 0
    t.integer "play_time", default: 0
    t.float "minpg", default: 0.0
    t.integer "pts", default: 0
    t.float "ppg", default: 0.0
    t.integer "fgm", default: 0
    t.integer "fga", default: 0
    t.float "fgpg", default: 0.0
    t.integer "three_m", default: 0
    t.integer "three_a", default: 0
    t.float "threepg", default: 0.0
    t.integer "ftm", default: 0
    t.integer "fta", default: 0
    t.float "ftpg", default: 0.0
    t.integer "ofr", default: 0
    t.integer "dfr", default: 0
    t.integer "tor", default: 0
    t.float "rpg", default: 0.0
    t.integer "assist", default: 0
    t.float "apg", default: 0.0
    t.integer "tover", default: 0
    t.integer "steal", default: 0
    t.float "stpg", default: 0.0
    t.integer "blockshot", default: 0
    t.float "bspg", default: 0.0
    t.integer "foul", default: 0
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["team_id", "created_at"], name: "index_players_on_team_id_and_created_at"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

end
